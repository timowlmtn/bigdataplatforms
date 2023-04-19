{%- macro
 test_args(
   integration_name,
   schema_name,
   table_name,
   pipe_name,
   stage_name,
   s3_url,
   columns,
   file_type
 )

-%}
{%- set sql -%}
begin;

   {%- for col, column_mapping in columns.items() %}
       select '{{ col }}', to_json({{ column_mapping }}
   {%- endfor %}
 );

commit;
{%- endset -%}

{%- do log(sql, info=True) -%}
{%- do run_query(sql) -%}
{%- do log("Auto-ingest pipe created", info=True) -%}
{%- endmacro -%}