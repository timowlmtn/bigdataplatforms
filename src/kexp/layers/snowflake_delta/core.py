def generate_external_table_ddl(table_name, stage, column_spec):
    columns = []
    for column_name in column_spec:
        columns.append(f"{column_name} {column_spec[column_name]} as "
                       f"(value:{column_name}::{column_spec[column_name]})")
    # id integer AS (value:id::integer)
    result = f"""
create or replace external table {table_name}({', '.join(columns)})
  location=@{stage}
  auto_refresh = false
  refresh_on_create = false
  file_format = (type = parquet)
  table_format = delta;
    """

    return result


def generate_aws_external_stage_ddl(s3_bucket,
                                    s3_stage,
                                    storage_integration,
                                    table_schema,
                                    table_name,
                                    delta_schema,
                                    delta_file):
    result = f"""
create or replace stage {table_schema.upper()}.STG_{delta_schema}_{table_name}
    storage_integration = {storage_integration}
    url = 's3://{s3_bucket}/{s3_stage}/{delta_file}';
    """

    return result
