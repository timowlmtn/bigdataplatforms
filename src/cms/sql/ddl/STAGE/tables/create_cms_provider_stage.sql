!set variable_substitution=true;
create or replace stage stage.CMS_PROVIDER_STG
storage_integration = &{STORAGE_INTEGRATION_NAME}
url = 's3://&{EXPORT_BUCKET}/stage/cms/provider/';
