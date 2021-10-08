!set variable_substitution=true;
-- This is the stage used to load the data into Snowflake
--
--  Run with Makefile through snowsql
--
use role &{DATABASE_ADMIN_ROLE};

create or replace stage &{DATABASE}.stage.KEXP_PUBLIC
storage_integration = &{STORAGE_INTEGRATION_NAME}
url = 's3://&{EXPORT_BUCKET}/stage/kexp/';

list @&{DATABASE}.stage.KEXP_PUBLIC;
