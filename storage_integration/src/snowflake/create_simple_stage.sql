!set variable_substitution=true;
create or replace stage &{STAGE_SCHEMA}.&{STAGE_ENDPOINT}
storage_integration = &{STORAGE_INTEGRATION_NAME}
url = 's3://&{SNOWFLAKE_BUCKET}/stage/prototype/simple';
