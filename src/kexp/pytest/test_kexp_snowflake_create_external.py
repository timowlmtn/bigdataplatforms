import unittest
import spark_catalog
from snowflake_delta import generate_external_table_ddl


class SnowflakeCreateExternalTest(unittest.TestCase):
    DELTA_LAKE_FOLDER = "../../../data/spark/kexp"

    catalog = spark_catalog.SparkCatalog(source_name="kexp", lake_location=DELTA_LAKE_FOLDER)

    def test_generate_sql(self):
        show_sql = self.catalog.get_data_frame("silver", "SHOW")
        show_sql.printSchema()

        self.assertEqual({'id': 'integer',
                          'image_uri': 'string',
                          'program': 'integer',
                          'program_name': 'string',
                          'program_tags': 'string',
                          'program_uri': 'string',
                          'silver_created_timestamp': 'timestamp',
                          'silver_modified_timestamp': 'timestamp',
                          'silver_source': 'string',
                          'start_time': 'timestamp',
                          'tagline': 'string',
                          'uri': 'string'}, self.catalog.get_schema_json("silver", "SHOW"))

    @staticmethod
    def test_to_external_ddl_columns():
        spec = {'id': 'integer',
                'image_uri': 'string',
                'program': 'integer',
                'program_name': 'string',
                'program_tags': 'string',
                'program_uri': 'string',
                'silver_created_timestamp': 'timestamp',
                'silver_modified_timestamp': 'timestamp',
                'silver_source': 'string',
                'start_time': 'timestamp',
                'tagline': 'string',
                'uri': 'string'}

        print(generate_external_table_ddl("STAGE.EXT_SILVER_SHOW", "STAGE.STG_SILVER_SHOW", spec))

    def test_variant(self):
        self.assertEqual({'airdate': 'timestamp',
                          'album': 'string',
                          'artist': 'string',
                          'artist_ids': 'variant',
                          'bronze_created_timestamp': 'timestamp',
                          'bronze_modified_timestamp': 'timestamp',
                          'bronze_source': 'string',
                          'comment': 'string',
                          'id': 'integer',
                          'image_uri': 'string',
                          'is_live': 'boolean',
                          'is_local': 'boolean',
                          'is_request': 'boolean',
                          'label_ids': 'variant',
                          'labels': 'variant',
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
                          'uri': 'string'}, self.catalog.get_schema_json("bronze", "KEXP_PLAYLIST"))
