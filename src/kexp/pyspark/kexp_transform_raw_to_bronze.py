import spark_catalog

import logging
import json
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def main():
    if os.getenv("RAW_DATA_FOLDER") is None or os.getenv("DELTA_LAKE_FOLDER") is None:
        print("run: export RAW_DATA_FOLDER=<your data> and DELTA_LAKE_FOLDER=<your lake location>")
    else:
        print(f'Running with {os.getenv("RAW_DATA_FOLDER")}')
        catalog = spark_catalog.SparkCatalog(app_name="kexp",
                                             lake_location=os.getenv("DELTA_LAKE_FOLDER"),
                                             raw_location=os.getenv("RAW_DATA_FOLDER"))

        print(json.dumps(catalog.append_bronze(raw_file_match="import_kexp_playlist.csv",
                                               table_name="import_kexp_playlist",
                                               change_column_id="PLAYLIST_ID"), indent=2))


if __name__ == "__main__":
    main()
