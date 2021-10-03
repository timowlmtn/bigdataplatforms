import re

import boto3
import unittest
import lakelayer
import datetime


#
# Author: Tim Burns
# License: Apache 2.0
#
# A Testing Class to Validate Scraping the KEXP Playlist for the blog
# https://www.owlmountain.net/
# If you like this, donate to KEXP: https://www.kexp.org/donate/
class KexpPlaylistHistoricalDataLakeTest(unittest.TestCase):
    session = boto3.Session(profile_name="owlmtn")
    s3_bucket = "azri.us-data"

    def test_get_historical(self):
        kexp_lake = lakelayer.KexpDataLake(s3_client=self.session.client("s3"),
                                           s3_bucket=self.s3_bucket,
                                           s3_stage="stage/kexp")
        kexp_reader = lakelayer.KexpApiReader()

        to_date = None
        time_end_date = datetime.datetime.now() + datetime.timedelta(days=-90)
        while to_date is None or to_date > time_end_date:
            playlist_map = kexp_reader.get_playlist(1000, airdate_before=kexp_lake.get_oldest_playlist_key())
            kexp_lake.put_playlist(playlist_map)
            kexp_lake.put_shows(kexp_reader.get_shows(playlist_map))
            to_date = datetime.datetime.strptime(kexp_lake.get_oldest_playlist_key(), kexp_reader.datetime_format_lake)
            print(to_date)


if __name__ == '__main__':
    unittest.main()
