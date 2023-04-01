#
# Author: Tim Burns
# License: Apache 2.0
#
# A Testing Class to Validate Scraping the KEXP Playlist for the blog
# https://www.owlmountain.net/
# If you like this, donate to KEXP: https://www.kexp.org/donate/
import unittest
import os
import json
import spark_catalog
from delta import DeltaTable
from pyspark import Row
from pyspark.sql.functions import col, explode, regexp_replace, split

class SparkCatalogTest(unittest.TestCase):

    DELTA_LAKE_FOLDER = "../../../data/spark/kexp"
    RAW_DATA_FOLDER = "../data/export"
    catalog = spark_catalog.SparkCatalog(app_name="kexp", lake_location=DELTA_LAKE_FOLDER, raw_location=RAW_DATA_FOLDER)

    def test_replace_null_chars(self):
        df = self.catalog.sql_context.createDataFrame([Row(col1='z1', col2='\\N', col3='foo')])
        print("Transform col2 to rows")
        df.withColumn(
            "col2", regexp_replace(col("col2"), "\\\\N", "")
        ).show()

        # The data frame does not keep the transform
        df.show()

    def test_truncate_bronze_kexp_playlist(self):
        self.catalog.truncate_bronze(table_name="import_kexp_playlist")

    def test_raw_playlist_to_bronze(self):
        self.catalog.append(raw_file_match="import_kexp_playlist.csv",
                            table_name="import_kexp_playlist",
                            change_column_id="PLAYLIST_ID")
