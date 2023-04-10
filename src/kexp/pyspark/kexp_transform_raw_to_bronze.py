import spark_catalog

import logging
import json
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def main():
    if os.getenv("RAW_DATA_FOLDER") is None or os.getenv("DELTA_LAKE_FOLDER") is None:
        exit("run: export RAW_DATA_FOLDER=<your data> and DELTA_LAKE_FOLDER=<your lake location>")

    result = {
    }

    catalog = spark_catalog.SparkCatalog(source_name="kexp",
                                         lake_location=f'{os.getenv("DELTA_LAKE_FOLDER")}/kexp',
                                         raw_location=f'{os.getenv("RAW_DATA_FOLDER")}/kexp')

    kexp_transform = {
        "hosts": {"table_name": "KEXP_HOST", "change_column_id": "ID"},
        "plays": {"table_name": "KEXP_PLAYLIST", "change_column_id": "ID"},
        "programs": {"table_name": "KEXP_PROGRAM", "change_column_id": "ID"},
        "shows": {"table_name": "KEXP_SHOW", "change_column_id": "ID"},
        "timeslots": {"table_name": "KEXP_TIMESLOT", "change_column_id": "ID"}
    }

    for raw_folder in kexp_transform.keys():
        result[raw_folder] = catalog.append_bronze(raw_file_match=f"{raw_folder}/**/*.jsonl",
                                                   table_name=kexp_transform[raw_folder]["table_name"],
                                                   change_column_id=kexp_transform[raw_folder]["change_column_id"])

    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
