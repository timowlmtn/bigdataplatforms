import boto3
import raw_data_api
import unittest
import json
import logging
import re

logging.basicConfig(level=logging.INFO)


class SparkCatalogTest(unittest.TestCase):
    api_reader = raw_data_api.ApiReader(source_api_url="https://api.kexp.org/v2")
    data_lake_handler = raw_data_api.DataLakeHandler(
        raw_data_api.LocalStorageProvider(root_folder="../../../data",
                                          stage_folder="raw/kexp"))
    raw_data_writer = raw_data_api.RawDataWriter(api_reader=api_reader, data_lake_handler=data_lake_handler)

    def test_sync_kexp_api(self):
        default_start_date = self.api_reader.get_default_start_date()
        print(json.dumps(self.api_reader.get_sync_api_calls(default_start_date), indent=2))

    def test_get_start_keys(self):
        print(json.dumps(self.api_reader.get_start_time_keys(), indent=2))

    def test_get_object_last_source_timestamp(self):
        self.assertEqual("../../../data", self.data_lake_handler.get_root_folder())
        self.assertEqual("raw/kexp", self.data_lake_handler.get_stage_folder())

        print(f'Shows: {self.data_lake_handler.get_object_last_source_timestamp("shows")}')
        default_end_date = self.api_reader.get_default_end_date()
        print(json.dumps(self.data_lake_handler.get_raw_folders(default_end_date), indent=2))

    def test_write_raw_data(self):
        self.assertEqual("../../../data", self.data_lake_handler.get_root_folder())

        match = re.match(r"(.*)/(.*)$", "../../../data/raw/kexp/plays/2023/04/04/20230404172626/plays_1.jsonl")
        self.assertTrue(match is not None)
        self.assertEqual("../../../data/raw/kexp/plays/2023/04/04/20230404172626", match.group(1))

        print(json.dumps(self.raw_data_writer.write_raw_data(self.data_lake_handler.get_root_folder()), indent=2))


