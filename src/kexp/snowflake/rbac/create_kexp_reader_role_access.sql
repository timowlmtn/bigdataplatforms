!set variable_substitution=true;
-- This is the stage used to load the data into Snowflake
--
--  Run with Makefile through snowsql
--
use role &{GRANTS_ADMIN_ROLE};


create or replace role KEXP_READER_ACCESS;
create or replace role KEXP_READER_FUNCTION;

grant role KEXP_READER_ACCESS to role KEXP_READER_FUNCTION;

grant usage on WAREHOUSE COMPUTE_WH to role KEXP_READER_ACCESS;

grant usage on database OWLMTN to role KEXP_READER_ACCESS;

grant usage on SCHEMA stage to role KEXP_READER_ACCESS;
grant usage on SCHEMA warehouse to role KEXP_READER_ACCESS;



