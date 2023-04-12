def generate_external_table_ddl(table_name, stage, column_spec):
    columns = []
    for column_name in column_spec:
        columns.append(f"{column_name} {column_spec[column_name]} as "
                       f"(value:{column_name}::{column_spec[column_name]})")
    # id integer AS (value:id::integer)
    result = f"""
create external table if not exists {table_name}({', '.join(columns)})
  location=@{stage}
  auto_refresh = false
  refresh_on_create = false
  file_format = (type = parquet)
  table_format = delta;
    """

    return result
