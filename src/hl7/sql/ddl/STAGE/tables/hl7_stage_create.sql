!set variable_substitution=true;
create or replace stage STAGE.HL7_STG
storage_integration = &{STORAGE_INTEGRATION_NAME}
url = 's3://&{EXPORT_BUCKET}/stage/hl7/';
