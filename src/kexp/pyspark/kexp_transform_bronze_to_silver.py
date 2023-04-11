import spark_catalog

import logging
import json
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def main():
    if os.getenv("RAW_DATA_FOLDER") is None or os.getenv("DELTA_LAKE_FOLDER") is None:
        exit("run: export RAW_DATA_FOLDER=<your data> and DELTA_LAKE_FOLDER=<your lake location>")

    source = "kexp"

    result = {
        source: {}
    }

    with open(f'{os.getenv("DELTA_LAKE_FOLDER")}/config/{source}/bronze_to_silver.json') as transform_file:
        transform = json.load(transform_file)

    for table_name in transform[source]:
        source_columns = ', '.join(transform[source][table_name]["source_columns"])
        source_table = transform[source][table_name]["source_table"]

        if "source_filter" in transform[source][table_name]:
            source_filter = f'where {transform[source][table_name]["source_filter"]}'
        else:
            source_filter = ""

        if "source_order" in transform[source][table_name]:
            source_order = f'{transform[source][table_name]["source_order"]}'
        else:
            source_order = ""

        result[source][table_name] = {}

        result[source][table_name]["sql"] = \
            f"select distinct {source_columns} from {source_table} {source_filter} {source_order}"

        catalog = spark_catalog.SparkCatalog(source_name=source,
                                             lake_location=f'{os.getenv("DELTA_LAKE_FOLDER")}/{source}',
                                             raw_location=f'{os.getenv("RAW_DATA_FOLDER")}/{source}')

        print(result[source][table_name]["sql"])

        if catalog.get_data_frame("bronze", transform[source][table_name]["source_table"]) is not None:

            data_frame = catalog.sql(result[source][table_name]["sql"])

            if "explode_array" in transform[source][table_name]:
                for column_name in transform[source][table_name]["explode_array"]:
                    data_frame = catalog.explode_array(data_frame, column_name)

            if "explode_string" in transform[source][table_name]:
                for column_name in transform[source][table_name]["explode_string"]:
                    data_frame = catalog.explode_string(data_frame, column_name)

            result[source][table_name]["export"] = catalog.append_changed(data_frame,
                                                                          "silver",
                                                                          table_name,
                                                                          transform[source][table_name][
                                                                              "target_identifier_columns"])
        else:
            print(f"WARNING: Could not find {transform[source][table_name]['source_table']}")

    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
