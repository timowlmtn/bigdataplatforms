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

create pipe if not exists {{ schema_name }}.{{ pipe_name }}
    AUTO_INGEST = true
    ERROR_INTEGRATION = S3_LAKE_KEXP_NOTIFICATION
as
    copy into {{ schema_name }}.{{ table_name }}(
        {%- for col, column_mapping in columns.items() %}
            {{ col }}{% if not loop.last %},{% endif %}
        {%- endfor %}
        )
    from (
        select {%- for col, column_mapping in columns.items() %}
            {% if column_mapping['DEFAULT'] is defined %}{{ column_mapping['DEFAULT'] }} {{ col }}
            {% else %}$1:{{ col }}::{{ column_mapping['DATA_TYPE'] }} {{ col }}{% endif %}{% if not loop.last %},{% endif %}
        {%- endfor %}
        from @{{ schema_name }}.{{ stage_name }}
    )
    FILE_FORMAT = (type = '{{ file_type }}')
    PATTERN = '.*.json';

commit;
{%- endset -%}

{%- do log(sql, info=True) -%}
{%- do run_query(sql) -%}
{%- do log("Auto-ingest pipe created", info=True) -%}
{%- endmacro -%}