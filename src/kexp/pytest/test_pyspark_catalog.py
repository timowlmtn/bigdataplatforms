import unittest
import os
import json
import spark_catalog


#
# Author: Tim Burns
# License: Apache 2.0
#
# A Testing Class to Validate Scraping the KEXP Playlist for the blog
# https://www.owlmountain.net/
# If you like this, donate to KEXP: https://www.kexp.org/donate/
class SparkCatalogTest(unittest.TestCase):

    DELTA_LAKE_FOLDER = "../../../data/spark/kexp"

    def test_get_metadata(self):
        catalog = spark_catalog.SparkCatalog(app_name="kexp", lake_location=os.getenv("DELTA_LAKE_FOLDER"))
        table_path = f"{self.DELTA_LAKE_FOLDER}/bronze/import_kexp_playlist"
        metadata = catalog.get_metadata(table_path)
        print(json.dumps(metadata, indent=2))
        self.assertTrue(metadata is not None)

    def test_get_schema(self):
        catalog = spark_catalog.SparkCatalog(app_name="kexp", lake_location=os.getenv("DELTA_LAKE_FOLDER"))
        table_path = f"{self.DELTA_LAKE_FOLDER}/bronze/import_kexp_playlist"
        table_schema = catalog.get_schema(table_path)
        print(json.dumps(table_schema, indent=2))
        self.assertTrue(table_schema is not None)