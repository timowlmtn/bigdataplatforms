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
        handler = spark_handler.SparkCore(app_name="kexp", lake_location=os.getenv("DELTA_LAKE_FOLDER"))

        show(handler, f"DESCRIBE HISTORY '{os.getenv('DELTA_LAKE_FOLDER')}/bronze/import_kexp_playlist'")
        show(handler, f"DESCRIBE DETAIL '{os.getenv('DELTA_LAKE_FOLDER')}/bronze/import_kexp_playlist'")
        # show(handler, f"DESCRIBE TABLE EXTENDED '{os.getenv('DELTA_LAKE_FOLDER')}/bronze/import_kexp_playlist'")


if __name__ == "__main__":
    main()

