import logging
import json
import os
import raw_data_api

logger = logging.getLogger()
logger.setLevel(logging.INFO)
global_error = None


def main():
    api_reader = raw_data_api.ApiReader(source_api_url="https://api.kexp.org/v2")
    data_lake_handler = raw_data_api.SparkDataCatalog(
        raw_data_api.LocalStorageProvider(root_folder="../../../data",
                                          stage_folder="raw/kexp"))

    raw_data_writer = raw_data_api.RawDataWriter(api_reader=api_reader, data_lake_handler=data_lake_handler)
    print(json.dumps(raw_data_writer.write_raw_data(data_lake_handler.get_root_folder(), 1000), indent=2))


if __name__ == "__main__":
    main()

