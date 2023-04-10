#
# Author: Tim Burns
# License: Apache 2.0
#
# A Testing Class to Validate Scraping the KEXP Playlist for the blog
# https://www.owlmountain.net/
# If you like this, donate to KEXP: https://www.kexp.org/donate/
import unittest
import re
from pyspark import Row
from pyspark.sql.functions import col, regexp_replace

import spark_catalog


class SparkCatalogTest(unittest.TestCase):
    DELTA_LAKE_FOLDER = "../../../data/spark/kexp"
    SNOWFLAKE_RAW_DATA_FOLDER = "../data/export"
    snowflake_catalog = spark_catalog.SparkCatalog(app_name="kexp",
                                                   lake_location=DELTA_LAKE_FOLDER,
                                                   raw_location=SNOWFLAKE_RAW_DATA_FOLDER)

    def test_replace_null_chars(self):
        df = self.snowflake_catalog.sql_context.createDataFrame([Row(col1='z1', col2='\\N', col3='foo')])
        print("Transform col2 to rows")
        df.withColumn(
            "col2", regexp_replace(col("col2"), "\\\\N", "")
        ).show()

        # The data frame does not keep the transform
        df.show()

    def test_truncate_bronze_kexp_playlist(self):
        self.snowflake_catalog.truncate_bronze(table_name="import_kexp_playlist")

    def test_infer_schema(self):
        self.assertEqual("csv", self.snowflake_catalog.get_file_type("../data/export/import_kexp_playlist.csv"))

        # Quick test on a regexp
        self.assertTrue(re.match(r"[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-9]{3} [\-\+]?[0-9]{4}",
                                 "2023-04-01 07:32:22.000 -0700"))
        schema = self.snowflake_catalog.infer_schema_raw(raw_file_match="import_kexp_playlist.csv")

        expected_result = {"AIRDATE": "timestamp",
                           "ALBUM": "string",
                           "ARTIST": "string",
                           "HOST_NAMES": "string",
                           "PLAYLIST_ID": "integer",
                           "PLAY_TYPE": "string",
                           "PROGRAM_ID": "integer",
                           "PROGRAM_NAME": "string",
                           "PROGRAM_TAGS": "string",
                           "RELEASE_DATE": "date",
                           "SHOW_ID": "integer",
                           "SONG": "string",
                           "START_TIME": "timestamp",
                           "TAGLINE": "string"}
        self.assertEqual(expected_result, schema)

    def test_infer_schema_raw(self):
        test_file = "../pytest/20230410061327/plays.jsonl"
        self.assertEqual("json", self.snowflake_catalog.get_file_type(test_file))

        self.assertEqual({'airdate': 'timestamp',
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
                          'uri': 'string'},
                         self.snowflake_catalog.infer_schema_raw(raw_file_match=test_file))
