import unittest
import os
import json
import spark_catalog
from delta import DeltaTable


#
# Author: Tim Burns
# License: Apache 2.0
#
# A Testing Class to Validate Scraping the KEXP Playlist for the blog
# https://www.owlmountain.net/
# If you like this, donate to KEXP: https://www.kexp.org/donate/
class SparkCatalogTest(unittest.TestCase):

    DELTA_LAKE_FOLDER = "../../../data/spark/kexp"

    catalog = spark_catalog.SparkCatalog(app_name="kexp", lake_location=DELTA_LAKE_FOLDER)

    def test_get_table(self):
        table = self.catalog.get_delta_table("bronze", "KEXP_PLAYLIST")
        print(table)
        self.assertFalse(table is None)

    def test_get_data_frame(self):
        df = self.catalog.get_data_frame("bronze", "KEXP_PLAYLIST")
        df.show()
        self.assertFalse(df is None)

    def test_get_metadata(self):
        metadata = self.catalog.get_metadata("bronze", "KEXP_PLAYLIST")
        print(json.dumps(metadata, indent=2))
        self.assertTrue(metadata is not None)

    def test_get_schema(self):
        table_schema = self.catalog.get_schema("bronze", "KEXP_PLAYLIST")
        print(json.dumps(table_schema, indent=2))
        self.assertTrue(table_schema is not None)

    def test_get_schema_api(self):
        delta_table = self.catalog.get_delta_table("bronze", "KEXP_PLAYLIST")
        table_df = delta_table.toDF()
        table_df.show()
        table_df.printSchema()  # Good
        print(table_df.schema)

    def test_sql(self):
        self.catalog.get_data_frame("bronze", "KEXP_PLAYLIST")
        self.catalog.sql("select count(*) as counts from KEXP_PLAYLIST").show()
