from datetime import datetime
import logging
import requests
import json
logging.basicConfig(level=logging.DEBUG)


class RawDataWriter:
    api_reader = None
    data_lake_handler = None

    def __init__(self, api_reader, data_lake_handler):
        self.api_reader = api_reader
        self.data_lake_handler = data_lake_handler

    def write_raw_data(self, raw_data_root):
        start_date = self.data_lake_handler.get_object_last_source_timestamp(raw_data_root)
        if start_date is None:
            start_date = self.api_reader.get_default_start_date()

        end_date = self.api_reader.get_default_end_date()
        api_calls = self.api_reader.get_sync_api_calls(end_date)
        output_folders = self.data_lake_handler.get_raw_folders(end_date)
        start_time_keys = self.api_reader.get_start_time_keys()

        result = {}

        for api_key in api_calls.keys():
            api_call = api_calls[api_key]

            result[api_key] = []
            print(f"API Call: {api_call}")
            page = requests.get(api_call)
            body_object = json.loads(page.text)
            idx = 0
            api_idx = 0

            print(start_date)
            count_exceeded = False
            print(f"API_KEY: {api_key}")
            while body_object['next'] is not None and count_exceeded is False:
                for jsonl in body_object['results']:
                    idx = idx + 1
                    folder = output_folders[api_key]
                    file_name = f"{folder}/{api_key}_{idx}.jsonl"
                    self.data_lake_handler.storage_provider.put_object(file_name=file_name,
                                                                       body=json.dumps(jsonl))
                    if start_time_keys[api_key]:
                        if datetime.strptime(jsonl[start_time_keys[api_key]],
                                             self.api_reader.datetime_format_api) < start_date:
                            count_exceeded = True

                    result[api_key].append(file_name)
                if body_object['next'] is not None:
                    api_idx = api_idx + 1
                    page = requests.get(body_object['next'])
                    body_object = json.loads(page.text)
                else:
                    break

        return result
