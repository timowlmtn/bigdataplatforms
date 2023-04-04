import boto3
import raw_data_api
import unittest
import json


class SparkCatalogTest(unittest.TestCase):
    api_reader = raw_data_api.ApiReader(source_api_url="https://api.kexp.org/v2")
    data_lake_handler = raw_data_api.DataLakeHandler(s3_client=boto3.Session().client("s3"),
                                                     s3_bucket="owlmtn-stage-data",
                                                     s3_stage="stage/raw/kexp")

    def test_sync_kexp_api(self):
        default_start_date = self.api_reader.get_default_start_date()
        print(json.dumps(self.api_reader.get_sync_api_calls(default_start_date), indent=2))

    def test_get_object_last_source_timestamp(self):
        print(self.data_lake_handler.get_object_last_source_timestamp("program"))
        default_start_date = self.api_reader.get_default_start_date()
        print(json.dumps(self.data_lake_handler.get_raw_output(default_start_date), indent=2))

