{%- macro
 destroy_s3_pipe(
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

drop pipe if exists {{ schema_name }}.{{ pipe_name }};
drop table if exists {{ schema_name }}.{{ table_name }};
drop stage if exists {{ schema_name }}.{{ stage_name }};
commit;
{%- endset -%}

{%- do log(sql, info=True) -%}
{%- do run_query(sql) -%}
{%- do log("Auto-ingest pipe destroyed", info=True) -%}
{%- endmacro -%}