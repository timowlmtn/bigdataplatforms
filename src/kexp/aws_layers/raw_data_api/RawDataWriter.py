from datetime import datetime
import logging
import requests
import json
logging.basicConfig(level=logging.DEBUG)


class RawDataWriter:
    api_reader = None
    data_lake_handler = None
    break_handler = 100

    def __init__(self, api_reader, data_lake_handler):
        self.api_reader = api_reader
        self.data_lake_handler = data_lake_handler

    def write_raw_data(self, raw_data_root, max_rows=100):
        last_sync_max_dates = self.data_lake_handler.get_sync_timestamps()

        start_date_map = {}

        # Use begin and dates for the last time the data was synced
        for key in last_sync_max_dates:
            start_date_map[key] = self.api_reader.get_default_start_date(
                self.data_lake_handler.timestamp_to_datetime(last_sync_max_dates[key]))

        end_date = self.api_reader.get_default_end_date()

        # print(f"\start_date: {start_date} end_date: {end_date}")

        api_calls = self.api_reader.get_sync_api_calls(start_date_map, end_date, max_rows)
        output_folders = self.data_lake_handler.get_raw_folders(end_date)

        result = {}

        for api_key in api_calls.keys():
            api_call = api_calls[api_key]

            result[api_key] = []

            page = requests.get(api_call)
            body_object = json.loads(page.text)
            idx = 0
            api_idx = 0

            while api_idx == 0 or body_object['next'] is not None:

                # print(f"\n{api_idx} {api_call} {api_key} {len(body_object['results'])}")

                for jsonl in body_object['results']:
                    idx = idx + 1
                    folder = output_folders[api_key]
                    file_name = f"{folder}/{api_key}_{idx}.jsonl"

                    self.data_lake_handler.storage_provider.put_object(file_name=file_name,
                                                                       body=json.dumps(jsonl))

                    result[api_key].append(file_name)

                # print(body_object['next'])
                if body_object['next'] is not None and len(body_object['results']) > 0:
                    page = requests.get(body_object['next'])
                    body_object = json.loads(page.text)
                else:
                    break

                api_idx = api_idx + 1
                if api_idx > self.break_handler:
                    raise Exception("Max api exceeded")

        return result
