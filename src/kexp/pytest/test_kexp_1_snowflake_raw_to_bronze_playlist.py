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
from pyspark import Row
from pyspark.sql.functions import col, regexp_replace

import spark_catalog


class SparkCatalogTest(unittest.TestCase):
    DELTA_LAKE_FOLDER = "../../../data/spark/kexp"
    SNOWFLAKE_RAW_DATA_FOLDER = "../../data/raw"
    catalog = spark_catalog.SparkCatalog(source_name="kexp",
                                         lake_location=DELTA_LAKE_FOLDER,
                                         raw_location=SNOWFLAKE_RAW_DATA_FOLDER)

    def test_replace_null_chars(self):
        df = self.catalog.sql_context.createDataFrame([Row(col1='z1', col2='\\N', col3='foo')])
        print("Transform col2 to rows")
        df.withColumn(
            "col2", regexp_replace(col("col2"), "\\\\N", "")
        ).show()

        # The data frame does not keep the transform
        df.show()

    def test_infer_schema(self):
        kexp_transform = {
            "plays": {"table_name": "KEXP_PLAYLIST", "change_column_id": "ID"}
        }

        root_folder = "../../../data/raw/kexp/plays/2023/04/12/20230412132149"
        for root, folder, files in sorted(os.walk(root_folder)):
            print(f"\nDEBUG: {root} {folder} {files}")
            for item in fnmatch.filter(files, "*.jsonl"):
                file = os.path.join(root, item)
                self.assertEqual("../../../data/raw/kexp/plays/2023/04/12/20230412132149/plays.jsonl", file)

                source_data = self.catalog.spark.read.load(file,
                                                           format=self.catalog.get_file_type(file),
                                                           inferSchema="true",
                                                           header="true")

                source_data.show()

                schema = self.catalog.infer_schema_raw("KEXP_PLAYLIST", file)

                expected_result = {'airdate': 'timestamp',
                                   'album': 'string',
                                   'artist': 'string',
                                   'artist_ids': 'array<string>',
                                   'comment': 'string',
                                   'id': 'integer',
                                   'image_uri': 'string',
                                   'is_live': 'boolean',
                                   'is_local': 'boolean',
                                   'is_request': 'boolean',
                                   'label_ids': 'array<string>',
                                   'labels': 'array<string>',
                                   'play_type': 'string',
                                   'recording_id': 'integer',
                                   'release_date': 'date',
                                   'release_group_id': 'integer',
                                   'release_id': 'integer',
                                   'rotation_status': 'string',
                                   'show': 'integer',
                                   'show_uri': 'string',
                                   'song': 'string',
                                   'thumbnail_uri': 'string',
                                   'track_id': 'integer',
                                   'uri': 'string'}
                self.assertEqual(expected_result, schema)
