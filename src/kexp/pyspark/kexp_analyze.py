import spark_handler

import logging

import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def show(handler, sql):
    print(sql)
    handler.sql(sql).show()


def main():
    if os.getenv("DELTA_LAKE_FOLDER") is None:
        print("run: DELTA_LAKE_FOLDER=<your lake location>")
    else:
        print(f'Running with {os.getenv("DELTA_LAKE_FOLDER")}')
        handler = spark_handler.SparkCatalog(app_name="kexp", lake_location=os.getenv("DELTA_LAKE_FOLDER"))

        table_path = f"{os.getenv('DELTA_LAKE_FOLDER')}/bronze/import_kexp_playlist"

        show(handler, f"DESCRIBE HISTORY ")
        show(handler, f"DESCRIBE DETAIL '{table_path}'")

        import_kexp_playlist = handler.get_table(table_path)

        # Print the metadata
        # print(import_kexp_playlist.metadata)


if __name__ == "__main__":
    main()

