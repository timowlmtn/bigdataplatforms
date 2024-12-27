import json
from pyhive import hive

# Hive connection details
hive_host = 'localhost'
hive_port = 10000
hive_database = 'default'
hive_table_name = 'kexp_host'
delta_table_path = 'src/mlflow/zillow_delta/KEXP_HOST'

# Delta log metadata
delta_log_metadata = '''
{
    "metaData": {
        "id": "3d4eebbb-156d-4089-a774-3555bf0fb81f",
        "format": {"provider": "parquet", "options": {}},
        "schemaString": "{\"type\":\"struct\",\"fields\":[{\"name\":\"id\",\"type\":\"integer\",\"nullable\":true,\"metadata\":{}},{\"name\":\"image_uri\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"is_active\",\"type\":\"boolean\",\"nullable\":true,\"metadata\":{}},{\"name\":\"name\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"thumbnail_uri\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"uri\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"bronze_source\",\"type\":\"string\",\"nullable\":true,\"metadata\":{}},{\"name\":\"bronze_created_timestamp\",\"type\":\"timestamp\",\"nullable\":true,\"metadata\":{}},{\"name\":\"bronze_modified_timestamp\",\"type\":\"timestamp\",\"nullable\":true,\"metadata\":{}}]}",
        "partitionColumns": [],
        "configuration": {},
        "createdTime": 1681331412807
    }
}
'''

# Parse Delta log metadata to extract schema
metadata = json.loads(delta_log_metadata)
schema_fields = json.loads(metadata['metaData']['schemaString'])['fields']

# Construct the schema for Hive
hive_schema = ",\n    ".join(
    f"{field['name']} {field['type'].upper()}" for field in schema_fields
)

# Connect to Hive
conn = hive.Connection(
    host=hive_host,
    port=hive_port,
    username='hive',
    database=hive_database
)
cursor = conn.cursor()

# Construct the CREATE TABLE query
create_table_query = f"""
CREATE EXTERNAL TABLE IF NOT EXISTS {hive_table_name} (
    {hive_schema}
)
STORED AS PARQUET
LOCATION '{delta_table_path}';
"""

# Execute the query to create the external table
try:
    print("Creating Hive external table...")
    cursor.execute(create_table_query)
    print("Hive external table created successfully.")
except Exception as e:
    print("Error creating Hive table:", e)
finally:
    cursor.close()
    conn.close()
