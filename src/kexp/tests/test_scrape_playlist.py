import re
import unittest
import urllib
import os
import json
import requests
import boto3
from datetime import datetime

import lakelayer;


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

    def test_get_playlist_api(self):
        page = requests.get(self.playlist_json)

        json_response = json.loads(page.text)

        # Create a unique folder for each request data lake style
        file_directory = f"data/kexp/{datetime.today().strftime('%Y%m%d%H%M%S')}"

        os.makedirs(file_directory)

        with open(f"{file_directory}/playlist.json", "w") as file_out:
            file_out.write(json.dumps(json_response, indent=2, sort_keys=True))

    def test_get_s3_data(self):
        kexp_lake = lakelayer.KexpDataLake(s3_client=self.session.client("s3"),
                                           s3_bucket=self.s3_bucket,
                                           s3_stage="stage/kexp")

        playlist_sets = kexp_lake.list_object_results()

        self.assertTrue("Expected non-empty result", len(playlist_sets) > 0)

        playlist_map = kexp_lake.get_playlist_object_map()
        target_value = 20210929084724
        self.assertTrue(f"Expected to find {target_value} in {playlist_map}", target_value in playlist_map)

    def test_datetime_parse(self):
        self.assertEqual("2020-09-28 11:53:50+00:00",
                         str(datetime.strptime("2020-09-28T11:53:50.000Z", "%Y-%m-%dT%H:%M:%S.%f%z")))

        self.assertTrue("2020-09-28 04:51:44-07:00",
                        str(datetime.strptime("2020-09-28T04:51:44-07:00", "%Y-%m-%dT%H:%M:%S%z")))

    def test_get_kexp_data(self):

        kexp_reader = lakelayer.KexpReader(airdate_before="2020-09-28T11:53:50.000Z")

        playlist_map = kexp_reader.get_playlist(10)

        #print(playlist_map.keys())

        # Validate that the dates are in order from newest to oldest
        last_date = None
        for playlist_key in playlist_map.keys():
            if last_date is None:
                last_date = playlist_key
            else:
                self.assertTrue(last_date > playlist_key)
                last_date = playlist_key

        print(last_date)


if __name__ == '__main__':
    unittest.main()
