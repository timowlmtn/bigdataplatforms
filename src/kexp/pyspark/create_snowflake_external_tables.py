import spark_catalog
import snowflake_delta

import logging
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)


def main():
    if os.getenv("ExportBucket") is None or \
            os.getenv("DELTA_LAKE_S3") is None or \
            os.getenv("DELTA_LAKE_FOLDER") is None or \
            os.getenv("STORAGE_INTEGRATION") is None:
        exit("Required environment variables not set.")

    source = "kexp"
    delta_schema = "silver"
    catalog = spark_catalog.SparkCatalog(source_name=source,
                                         lake_location=f'{os.getenv("DELTA_LAKE_FOLDER")}/{source}')

    for file in os.listdir(f'{os.getenv("DELTA_LAKE_FOLDER")}/{source}/{delta_schema}'):
        with open(f'snowflake_create_ext_delta_{file.lower()}.sql', "w") as sql_file_out:
            sql_file_out.write(f"\n--------------------------------------- {file}")

            sql_file_out.write(snowflake_delta.generate_aws_external_stage_ddl(s3_bucket=os.getenv("ExportBucket"),
                                                                  s3_stage=os.getenv("DELTA_LAKE_S3"),
                                                                  storage_integration=os.getenv("STORAGE_INTEGRATION"),
                                                                  table_schema=os.getenv("SNOWFLAKE_LANDING_ZONE"),
                                                                  table_name=file,
                                                                  delta_schema=delta_schema.upper(),
                                                                  delta_file=f"{delta_schema}/{file}"))

            sql_file_out.write(f'\nlist @{os.getenv("SNOWFLAKE_LANDING_ZONE")}.STG_{delta_schema.upper()}_{file};\n')

            data_frame_schema = catalog.get_schema_json("silver", file)

            sql_file_out.write(snowflake_delta.generate_external_table_ddl(table_name=f'{os.getenv("SNOWFLAKE_LANDING_ZONE")}.'
                                                                              f'EXT_{delta_schema.upper()}_{file}',
                                                                   stage=f'{os.getenv("SNOWFLAKE_LANDING_ZONE")}.'
                                                                         f'STG_{delta_schema.upper()}_{file}',
                                                                   column_spec=data_frame_schema))
            sql_file_out.write(
                f'\nalter external table '
                f'{os.getenv("SNOWFLAKE_LANDING_ZONE")}.EXT_{delta_schema.upper()}_{file} refresh;\n')

            sql_file_out.write(f'\nselect * '
                               f'from {os.getenv("SNOWFLAKE_LANDING_ZONE")}.EXT_{delta_schema.upper()}_{file};\n')

if __name__ == "__main__":
    main()
