#
# Author: Tim Burns
# License: Apache 2.0
#
# A Testing Class to Validate Scraping the KEXP Playlist for the blog
# https://www.owlmountain.net/
# If you like this, donate to KEXP: https://www.kexp.org/donate/

import unittest
import os
import spark_catalog

from pyspark import Row
from pyspark.sql.functions import col, explode, regexp_replace, split


class SparkCatalogTest(unittest.TestCase):
    DELTA_LAKE_FOLDER = "../../../data/spark/kexp"

    catalog = spark_catalog.SparkCatalog(app_name="kexp", lake_location=DELTA_LAKE_FOLDER)

    def test_regexp_replace(self):
        df = self.catalog.sql_context.createDataFrame([Row(col1='z1', col2='[a1, b2, c3]', col3='foo')])
        df.show()
        df.printSchema()

        print("Get rid of [ and ] in col2")
        df.withColumn(
            "col2", regexp_replace(col("col2"), "(^\[)|(\]$)", "")
        ).show()

    def test_col_to_array(self):
        df = self.catalog.sql_context.createDataFrame([Row(col1='z1', col2='[a1, b2, c3]', col3='foo')])

        df.withColumn(
            "col2", regexp_replace(col("col2"), "(^\[)|(\]$)", "")
        ).printSchema()

        print("Turn col2 into an array")
        df.withColumn(
            "col2",
            split(regexp_replace(col("col2"), "(^\[)|(\]$)", ""), ", ")
        ).show()

    def test_transform_to_rows(self):
        df = self.catalog.sql_context.createDataFrame([Row(col1='z1', col2='[a1, b2, c3]', col3='foo')])
        print("Transform col2 to rows")
        df.withColumn(
            "col2",
            explode(split(regexp_replace(col("col2"), "(^\[)|(\]$)", ""), ", "))
        ).show()

    def test_explode_program_tags(self):
        df = self.catalog.sql_context.createDataFrame(
            [Row(ARTIST='R.E.M.',
                 PROGRAM_TAGS='Rock,Eclectic,Variety Mix',
                 HOST_NAMES='"[:"Cheryl Waters"",""Eva Walker""]"')])
        df.withColumn(
            "PROGRAM_TAGS",
            explode(split(regexp_replace(col("PROGRAM_TAGS"), "(^\[)|(\]$)", ""), ","))
        ).show()

    def test_explode_program_tags_delta(self):
        table_path = f"{self.DELTA_LAKE_FOLDER}/bronze/import_kexp_playlist"
        table = self.catalog.get_table(table_path)
        table_flattened = table.toDF()
        table_flattened.withColumn(
             "PROGRAM_TAGS",
            explode(split(regexp_replace(col("PROGRAM_TAGS"), "(^\[)|(\]$)", ""), ","))
        ).show()

    def test_explode_program_tags_core(self):
        self.assertEqual('../../../data/spark/kexp/silver', self.catalog.silver_location)
        table_df = self.catalog.get_data_frame(f"{self.DELTA_LAKE_FOLDER}/bronze/import_kexp_playlist")
        self.catalog.explode(table_df, "PROGRAM_TAGS", target_name="KEXP_PLAYLIST_1NF", column_separating=",")

    def test_review_silver(self):
        playlist = self.catalog.get_silver_df("KEXP_PLAYLIST_1NF")
        playlist.show()

    def test_truncate_silver(self):
        self.catalog.truncate_silver("KEXP_PLAYLIST_1NF")
