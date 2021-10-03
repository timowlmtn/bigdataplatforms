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
    session = boto3.Session(profile_name="owlmtn")
    s3_bucket = "azri.us-data"

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

        kexp_reader = lakelayer.KexpApiReader(airdate_before_date=datetime.strptime("2020-09-28T04:51:44-07:00",
                                                                                    "%Y-%m-%dT%H:%M:%S%z"))

        playlist_map = kexp_reader.get_playlist(10)

        # Make sure the last date is always consistent
        overall_last_date = 20200928040741
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

        kexp_reader = lakelayer.KexpApiReader(airdate_before_date=datetime.strptime("2020-09-28T04:51:44-07:00",
                                                                                    "%Y-%m-%dT%H:%M:%S%z"))

        kexp_lake.put_playlist(kexp_reader.get_playlist(10))

        kexp_lake.put_shows(kexp_reader.get_shows())

    def test_get_shows(self):
        kexp_reader = lakelayer.KexpApiReader(airdate_before_date=datetime.strptime("2020-09-28T04:51:44-07:00",
                                                                                    "%Y-%m-%dT%H:%M:%S%z"))
        kexp_reader.get_playlist(10)
        kexp_shows = kexp_reader.get_shows()

        expected_result = {48339: {'id': 48339, 'uri': 'https://api.kexp.org/v2/shows/48339/?format=json', 'program': 4,
                                   'program_uri': 'https://api.kexp.org/v2/programs/4/?format=json', 'hosts': [24],
                                   'host_uris': ['https://api.kexp.org/v2/hosts/24/?format=json'],
                                   'program_name': 'Jazz Theatre', 'program_tags': 'Jazz',
                                   'host_names': ['John Gilbreath'], 'tagline': '',
                                   'image_uri': 'https://www.kexp.org/filer/canonical/1529970959/10640/',
                                   'start_time': '2020-09-28T03:00:50-07:00'}}

        self.assertEqual(expected_result, kexp_shows)

    def test_get_all(self):
        kexp_reader = lakelayer.KexpApiReader()
        kexp_lake = lakelayer.KexpDataLake(s3_client=self.session.client("s3"),
                                           s3_bucket=self.s3_bucket,
                                           s3_stage="stage/kexp")
        kexp_lake.put_playlist(kexp_reader.get_playlist(10))
        kexp_lake.put_shows(kexp_reader.get_shows())

if __name__ == '__main__':
    unittest.main()
