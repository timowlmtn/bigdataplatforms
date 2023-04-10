#
# Author: Tim Burns
# License: Apache 2.0
#
# A Testing Class to Validate Scraping the KEXP Playlist for the blog
# https://www.owlmountain.net/
# If you like this, donate to KEXP: https://www.kexp.org/donate/
import unittest
import os
import fnmatch

import reporting.layers.awslayer
import spark_catalog


class SparkCatalogTest(unittest.TestCase):
    DELTA_LAKE_FOLDER = "../../../data/spark/kexp"
    SNOWFLAKE_RAW_DATA_FOLDER = "../../../data/raw/kexp"
    spark_catalog = spark_catalog.SparkCatalog(source_name="kexp",
                                               lake_location=DELTA_LAKE_FOLDER,
                                               raw_location=SNOWFLAKE_RAW_DATA_FOLDER)

    def test_walk_regexp(self):
        # A test to validate how to specify a raw file match
        (root_folder, target_file) = "shows/**/*.jsonl".split("/**/")

        self.assertEqual("shows", root_folder)
        self.assertEqual("*.jsonl", target_file)

        for root, folder, files in os.walk(os.path.join(self.spark_catalog.raw_location, root_folder)):
            for item in fnmatch.filter(files, target_file):
                print(f"\t{root}/{item}")

    def test_spark_load_direct(self):
        file = "../../../data/raw/kexp/shows/2023/04/07/20230407150758/shows.jsonl"
        self.assertEqual("json", self.spark_catalog.get_file_type(file))

    def test_load_raw_to_bronze(self):
        self.assertEqual("../../../data/raw/kexp", self.spark_catalog.raw_location)

        self.assertTrue(type("The Afternoon Show") == str)
        self.assertTrue(type(["A", "B"]) == list)
        self.assertTrue(type(123) == int)

        self.spark_catalog.append_bronze("shows/**/*.jsonl", "KEXP_SHOW", "ID")

    def test_get_max_id_bronze(self):
        max_id = self.spark_catalog.max(table_schema="bronze", table_name="KEXP_SHOW", column_name="ID")
        print(f"Max ID for KEXP_SHOW  = {max_id}")
        self.assertTrue(max_id is None or max_id > 0)
