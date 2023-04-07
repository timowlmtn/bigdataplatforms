import datetime
import raw_data_api
import unittest
import json
import logging
import re

logging.basicConfig(level=logging.INFO)


class SparkCatalogTest(unittest.TestCase):
    api_reader = raw_data_api.ApiReader(source_api_url="https://api.kexp.org/v2")
    data_lake_handler = raw_data_api.SparkDataCatalog(
        raw_data_api.LocalStorageProvider(root_folder="../../../data",
                                          stage_folder="raw/kexp"))
    raw_data_writer = raw_data_api.RawDataWriter(api_reader=api_reader, data_lake_handler=data_lake_handler)

    def test_sync_kexp_api(self):
        default_start_date = self.api_reader.get_default_start_date()
        default_end_date = self.api_reader.get_default_end_date()
        print(json.dumps(self.api_reader.get_sync_api_calls(default_start_date, default_end_date), indent=2))

    def test_get_start_keys(self):
        print(json.dumps(self.api_reader.get_start_time_keys(), indent=2))

    def test_get_object_last_source_timestamp(self):
        self.assertEqual("../../../data", self.data_lake_handler.get_root_folder())
        self.assertEqual("raw/kexp", self.data_lake_handler.get_stage_folder())
        last_timestamp = self.data_lake_handler.get_object_last_source_timestamp("shows")
        print(f'\nDelete all files for none {last_timestamp}')

        print(f'None type defaults {self.api_reader.get_default_start_date(last_timestamp)}')

        print(f'Shows: {self.data_lake_handler.get_object_last_source_timestamp("shows")}')
        default_end_date = self.api_reader.get_default_end_date()
        print(json.dumps(self.data_lake_handler.get_raw_folders(default_end_date), indent=2))

    def test_default_timestamps(self):
        """
        Test will make sure our local time EST converts to the PST for the target API.
        """
        last_sync_max_date = self.data_lake_handler.get_object_last_source_timestamp("../../../data/shows")

        if last_sync_max_date is None:
            last_sync_max_date = 20230407122226

        self.assertTrue(last_sync_max_date >= 20230407122226)

        self.assertEqual(datetime.datetime(2023, 4, 7, 12, 22, 26),
                         self.data_lake_handler.timestamp_to_datetime(20230407122226))

        start_date = self.api_reader.get_default_start_date(
            self.data_lake_handler.timestamp_to_datetime(last_sync_max_date))

        print(f"\nConvert: EST {self.data_lake_handler.timestamp_to_datetime(last_sync_max_date)} PST {start_date}")

        end_date = self.api_reader.get_default_end_date()

        self.assertTrue(start_date < end_date)

    def test_sync_dates(self):
        sync_timestamp_map = self.data_lake_handler.get_sync_timestamps()
        print(sync_timestamp_map)
        self.assertTrue("shows" in sync_timestamp_map)

    def test_write_raw_data(self):

        self.assertEqual("../../../data", self.data_lake_handler.get_root_folder())

        match = re.match(r"(.*)/(.*)$", "../../../data/raw/kexp/plays/2023/04/04/20230404172626/plays_1.jsonl")
        self.assertTrue(match is not None)
        self.assertEqual("../../../data/raw/kexp/plays/2023/04/04/20230404172626", match.group(1))
        root_folder = self.data_lake_handler.get_root_folder()
        self.assertEqual("../../../data", root_folder)
        stage_folder = self.data_lake_handler.get_stage_folder()
        self.assertEqual("raw/kexp", stage_folder)
        last_source_timestamp = self.data_lake_handler\
            .get_object_last_source_timestamp(f"{root_folder}/{stage_folder}/plays")
        print(last_source_timestamp)
        if last_source_timestamp is not None:
            self.assertTrue(last_source_timestamp >= 20230407074041, "Expected increasing timestamp")

        print(json.dumps(self.raw_data_writer.write_raw_data(self.data_lake_handler.get_root_folder(), 50), indent=2))


