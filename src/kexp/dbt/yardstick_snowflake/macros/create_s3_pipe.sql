{%- macro
 create_s3_pipe(
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
create schema if not exists {{  schema_name }};

create stage if not exists {{  schema_name }}.{{ stage_name }}
storage_integration = {{ integration_name }}
url = "{{ s3_url }}";

create table if not exists {{ schema_name }}.{{ table_name }} (
   {%- for col, column_mapping in columns.items() %}
   {{ col }} {{ column_mapping['DATA_TYPE'] }}{% if not loop.last %},{% endif %}
   {%- endfor %}
 );

create pipe {{ schema_name }}.{{ pipe_name }}
    auto_ingest = true as
    copy into {{ schema_name }}.{{ table_name }}
    from @{{ schema_name }}.{{ stage_name }}
    file_format = (
     type = '{{ file_type }}'
   );

commit;
{%- endset -%}

{%- do log(sql, info=True) -%}
{%- do run_query(sql) -%}
{%- do log("Auto-ingest pipe created", info=True) -%}
{%- endmacro -%}