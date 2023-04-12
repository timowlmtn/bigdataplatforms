
--------------------------------------- PROGRAM
create or replace stage STAGE.STG_SILVER_PROGRAM
    storage_integration = OWLMTN_S3_DATA
    url = 's3://owlmtn-stage-data/stage/kexp/delta/silver/PROGRAM/';
    
list @STAGE.STG_SILVER_PROGRAM;

create or replace external table STAGE.EXT_SILVER_PROGRAM(
id integer as (value:id::integer)
    , description string as (value:description::string)
    , is_active boolean as (value:is_active::boolean)
    , name string as (value:name::string)
    , tags string as (value:tags::string)
    , uri string as (value:uri::string)
    , silver_source string as (value:silver_source::string)
    , silver_created_timestamp timestamp as (value:silver_created_timestamp::timestamp)
    , silver_modified_timestamp timestamp as (value:silver_modified_timestamp::timestamp))
  location=@STAGE.STG_SILVER_PROGRAM
  auto_refresh = false
  refresh_on_create = false
  file_format = (type = parquet)
  table_format = delta;
    
alter external table STAGE.EXT_SILVER_PROGRAM refresh;

select * from STAGE.EXT_SILVER_PROGRAM;
