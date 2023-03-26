import json
import logging
import os
import unittest
from datetime import datetime
import boto3

import lakelayer


# root = logging.getLogger()
# root.setLevel(logging.DEBUG)

# import sys
# handler = logging.StreamHandler(sys.stdout)
# handler.setLevel(logging.DEBUG)
# formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
# handler.setFormatter(formatter)
# root.addHandler(handler)

#
# Author: Tim Burns
# License: Apache 2.0
#
# A Testing Class to Validate Scraping the KEXP Playlist for the blog
# https://www.owlmountain.net/
# If you like this, donate to KEXP: https://www.kexp.org/donate/
#
# In order to have this work, set the following environment variables
#
# AWS_PROFILE
# S3_STAGE_BUCKET
#
class KexpPlaylistDataLakeTest(unittest.TestCase):
    session = boto3.Session(profile_name=os.getenv("AWS_PROFILE"))
    s3_bucket = os.getenv("S3_STAGE_BUCKET")

    kexp_reader = lakelayer.KexpApiReader()

    # -------------------------------------------------------------------------------------------------
    # Unit test for the Lambda function that we deploy to AWS
    # See src/kexp/aws_cloudformation/kexp_lambda_function.py
    #
    def test_sync_kexp_s3(self):
        stage = "stage/kexp"
        print(f'append_playlist: aws_profile={os.getenv("AWS_PROFILE")} s3_bucket={self.s3_bucket} stage={stage}')

        assert("Set bucket: export S3_STAGE_BUCKET=my-aws-datalake", self.s3_bucket is not None)

        kexp_lake = lakelayer.KexpDataLake(s3_client=self.session.client("s3"),
                                           s3_bucket=self.s3_bucket,
                                           s3_stage=stage)

        current_key = kexp_lake.get_newest_playlist_key();
        print(current_key)

        self.assertTrue(20220924101047 < int(current_key))

        (runtime_key, airdate_before_date, airdate_after_date) = kexp_lake.get_airdates()
        print(f"{runtime_key} {airdate_before_date} {airdate_after_date}")

        (runtime_key, airdate_before_date, airdate_after_date) = kexp_lake.get_airdates()

        playlist_map = self.kexp_reader.get_playlist(read_rows=lakelayer.kexp_max_rows,
                                                     airdate_after_date=airdate_after_date,
                                                     airdate_before_date=airdate_before_date)
        shows_map = self.kexp_reader.get_shows(playlist_map)

        result = kexp_lake.put_data(runtime_key, playlist_map, shows_map, airdate_after_date, airdate_before_date)

        print(json.dumps(result, indent=2))


if __name__ == '__main__':
    unittest.main()
