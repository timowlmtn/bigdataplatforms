import boto3
import unittest
import lakelayer
from datetime import datetime
from datetime import timedelta
import json
import pytz


#
# Author: Tim Burns
# License: Apache 2.0
#
# A Testing Class to Validate Scraping the KEXP Playlist for the blog
# https://www.owlmountain.net/
# If you like this, donate to KEXP: https://www.kexp.org/donate/
class KexpPlaylistHistoricalDataLakeTest(unittest.TestCase):
    session = boto3.Session(profile_name="owlmtn")
    s3_bucket = "owlmtn-stage-data"

    def test_get_historical(self):
        kexp_lake = lakelayer.KexpDataLake(s3_client=self.session.client("s3"),
                                           s3_bucket=self.s3_bucket,
                                           s3_stage="stage/kexp")
        kexp_reader = lakelayer.KexpApiReader()

        utc = pytz.UTC
        time_end_date = datetime.now() - timedelta(days=4*365)
        oldest_playlist_record = kexp_lake.list_playlists()[0]
        print(oldest_playlist_record)
        obj = self.session.client("s3").get_object(Bucket=self.s3_bucket,
                                                               Key=oldest_playlist_record["Key"])
        print(obj)
        oldest_playlist_array = obj['Body'].read().decode("utf-8").split("\n")

        print(json.loads(oldest_playlist_array[0])['airdate'] + "\n\t" +
              json.loads(oldest_playlist_array[(len(oldest_playlist_array))-1])['airdate'])

        airdate_before = datetime.strptime(json.loads(oldest_playlist_array[(len(oldest_playlist_array))-1])['airdate'],
                                           lakelayer.datetime_format_api)

        playlist_map = None
        print(f"{utc.localize(time_end_date)} to {airdate_before}")
        # When there is only one key, we have exhausted the range
        while playlist_map is None or len(playlist_map.keys()) > 1:
            print(f"{time_end_date} to {airdate_before}")
            playlist_map = kexp_reader.get_playlist(read_rows=1000,
                                                    airdate_after_date=time_end_date,
                                                    airdate_before_date=airdate_before)
            print(len(playlist_map.keys()))

            if len(playlist_map.keys()) == 0:
                break
            else:
                last_index = len(playlist_map.keys())-1
                airdate_before = datetime.strptime(playlist_map[list(playlist_map.keys())[last_index]]['airdate'],
                                                   lakelayer.datetime_format_api)

            runtime_key = datetime.strftime(airdate_before, lakelayer.datetime_format_lake)
            print(runtime_key)

            if len(playlist_map.keys()) > 1:
                shows_map = kexp_reader.get_shows(playlist_map)
                result = kexp_lake.put_data(runtime_key, playlist_map, shows_map, time_end_date, airdate_before)
                print(result)


if __name__ == '__main__':
    unittest.main()
