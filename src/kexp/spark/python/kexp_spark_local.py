import spark_handler

import logging
import json
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def main():
    if os.getenv("RAW_DATA_FOLDER") is None:
        print("run: export RAW_DATA_FOLDER=<your data>")
    else:
        print(f'Running with {os.getenv("RAW_DATA_FOLDER")}')
        handler = spark_handler.SparkCore(app_name="kexp", root_location=".")
        print(json.dumps(handler.process_raw_to_bronze(
                raw_data_folder= os.getenv("RAW_DATA_FOLDER"),
                file_match="import_kexp_playlist.csv"), indent=2))


if __name__ == "__main__":
    main()

