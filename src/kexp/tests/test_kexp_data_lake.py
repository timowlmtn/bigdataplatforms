import re
import os
import json
import boto3
import unittest
import lakelayer
from datetime import datetime


#
# Author: Tim Burns
# License: Apache 2.0
#
# A Testing Class to Validate Scraping the KEXP Playlist for the blog
# https://www.owlmountain.net/
# If you like this, donate to KEXP: https://www.kexp.org/donate/
class KexpPlaylistDataLakeTest(unittest.TestCase):
    session = boto3.Session(profile_name=os.getenv("AWS_PROFILE"))
    s3_bucket = os.getenv("S3_STAGE_BUCKET")

    def test_get_s3_data(self):
        kexp_lake = lakelayer.KexpDataLake(s3_client=self.session.client("s3"),
                                           s3_bucket=self.s3_bucket,
                                           s3_stage="stage/kexp_test")

        playlist_sets = kexp_lake.list_object_results("stage/kexp_test")

        self.assertTrue("Expected non-empty result", len(playlist_sets) > 0)

        playlist_map = kexp_lake.get_playlist_object_map()
        target_value = 20210929084724
        self.assertTrue(f"Expected to find {target_value} in {playlist_map}", target_value in playlist_map)

    def test_datetime_parse(self):
        # Play with the date format to get it right
        self.assertEqual("2020-09-28 11:53:50+00:00",
                         str(datetime.strptime("2020-09-28T11:53:50.000Z", "%Y-%m-%dT%H:%M:%S.%f%z")))

        self.assertTrue("2020-09-28 04:51:44-07:00",
                        str(datetime.strptime("2020-09-28T04:51:44-07:00", "%Y-%m-%dT%H:%M:%S%z")))

        self.assertTrue("2020-09-28T04:51:44-07:00",
                        datetime.strftime(
                            datetime.strptime("2020-09-28T04:51:44-07:00",
                                              "%Y-%m-%dT%H:%M:%S%z"),
                            "%Y-%m-%dT%H:%M:%S%z"))

    def test_get_kexp_data(self):

        kexp_reader = lakelayer.KexpApiReader()

        playlist_map = kexp_reader.get_playlist(10,
                                                airdate_before_date=datetime.strptime("20211003103231",
                                                                                      lakelayer.datetime_format_lake))

        # Make sure the last date is always consistent
        overall_last_date = 20211003100054
        # Validate that the dates are in order from newest to oldest
        last_date = None
        for playlist_key in playlist_map.keys():
            if last_date is None:
                last_date = playlist_key
            else:
                self.assertTrue(last_date > playlist_key)
                last_date = playlist_key

        self.assertEqual(overall_last_date, last_date)

    def test_put_kexp_data(self):
        # Use the Web request and S3 objects together to dump the data
        kexp_lake = lakelayer.KexpDataLake(s3_client=self.session.client("s3"),
                                           s3_bucket=self.s3_bucket,
                                           s3_stage="stage/kexp_test")

        kexp_reader = lakelayer.KexpApiReader()

        kexp_playlists = kexp_reader.get_playlist(10)
        kexp_lake.put_playlist(kexp_playlists)

        kexp_lake.put_shows(kexp_reader.get_shows(kexp_playlists))

    def test_get_shows(self):
        kexp_reader = lakelayer.KexpApiReader()

        playlist_map = kexp_reader.get_playlist(1,
                                                airdate_before_date=datetime.strptime("20211003175919",
                                                                                      lakelayer.datetime_format_lake))

        kexp_shows = kexp_reader.get_shows(playlist_map)

        expected_result = {51688: {'host_names': ['Evie'],
                                   'host_uris': ['https://api.kexp.org/v2/hosts/19/?format=json'],
                                   'hosts': [19],
                                   'id': 51688,
                                   'image_uri': 'https://www.kexp.org/filer/canonical/1529968671/10622/',
                                   'program': 18,
                                   'program_name': 'Variety Mix',
                                   'program_tags': 'Rock,Eclectic,Variety Mix',
                                   'program_uri': 'https://api.kexp.org/v2/programs/18/?format=json',
                                   'start_time': '2021-10-03T15:03:15-07:00',
                                   'tagline': 'Fall Fund Drive!  @djeviestokes',
                                   'uri': 'https://api.kexp.org/v2/shows/51688/?format=json'}}

        self.assertEqual(kexp_shows, expected_result)

    def test_get_recent(self):
        kexp_lake = lakelayer.KexpDataLake(s3_client=self.session.client("s3"),
                                           s3_bucket=self.s3_bucket,
                                           s3_stage="stage/kexp_test")

        kexp_reader = lakelayer.KexpApiReader()
        playlist_map = kexp_reader.get_playlist(airdate_after_date=kexp_lake.get_newest_playlist_date(),
                                                airdate_before_date=datetime.now())
        playlist_key = kexp_lake.put_playlist(playlist_map)

        self.assertTrue(playlist_key.startswith("stage/kexp_test/playlists/"))

        shows_key = kexp_lake.put_shows(kexp_reader.get_shows(playlist_map))

        self.assertTrue(shows_key.startswith("stage/kexp_test/shows/"))

    def test_get_newest_oldest(self):

        kexp_lake = lakelayer.KexpDataLake(s3_client=self.session.client("s3"),
                                           s3_bucket=self.s3_bucket,
                                           s3_stage="stage/kexp_test")

        oldest_playlist_key = kexp_lake.get_oldest_playlist_key()
        print(oldest_playlist_key)
        newest_playlist_key = kexp_lake.get_newest_playlist_key()

        self.assertTrue(oldest_playlist_key < newest_playlist_key)

    def test_like_lambda(self):
        export_stage = "stage/kexp_test"

        kexp_lake = lakelayer.KexpDataLake(s3_client=self.session.client("s3"),
                                           s3_bucket=self.s3_bucket,
                                           s3_stage=export_stage)

        kexp_reader = lakelayer.KexpApiReader()

        airdate_after_date = kexp_lake.get_newest_playlist_date()
        airdate_before_date = datetime.now()
        playlist_map = kexp_reader.get_playlist(airdate_after_date=airdate_after_date,
                                                airdate_before_date=airdate_before_date)
        playlist_key = kexp_lake.put_playlist(playlist_map)
        shows_key = kexp_lake.put_shows(kexp_reader.get_shows(playlist_map))

        result = {"airdate_after_date": datetime.strftime(airdate_after_date, lakelayer.datetime_format_api),
                  "airdate_before_date": datetime.strftime(airdate_before_date, lakelayer.datetime_format_api),
                  "playlist_key": playlist_key,
                  "shows_key": shows_key}

        for timestamp in playlist_map.keys():
            kexp_lake.put_object(f"{export_stage}/logs/{timestamp}/api{timestamp}.json",  json.dumps(result))


if __name__ == '__main__':
    unittest.main()
