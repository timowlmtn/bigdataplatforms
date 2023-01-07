!set variable_substitution=true;
create stage if not exists &{STAGE_SCHEMA}.&{STAGE_ENDPOINT}
storage_integration = &{STORAGE_INTEGRATION_NAME}
url = 's3://&{EXPORT_BUCKET}/stage/prototype/simple';
