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
