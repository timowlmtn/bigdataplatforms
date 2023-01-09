!set variable_substitution=true;
-- Create the Stage data.
-- For more information see
--
--   https://docs.snowflake.com/en/sql-reference/sql/create-storage-integration.html
--
use role ACCOUNTADMIN;

CREATE or REPLACE STORAGE INTEGRATION &{STORAGE_INTEGRATION_NAME}
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  STORAGE_AWS_ROLE_ARN = '&{SNOWFLAKE_INTEGRATION_ROLE}'
  ENABLED = TRUE
  STORAGE_ALLOWED_LOCATIONS = ('s3://&{SNOWFLAKE_BUCKET}/stage')
  COMMENT = 'Storage Integration for Snowflake Stage Data';

grant create stage on schema &{DATABASE}.stage to role &{DATABASE_ADMIN_ROLE};

grant usage on integration &{STORAGE_INTEGRATION_NAME} to role &{DATABASE_ADMIN_ROLE};

desc integration &{STORAGE_INTEGRATION_NAME}; -- Use these values in the CloudFormation Role Template
