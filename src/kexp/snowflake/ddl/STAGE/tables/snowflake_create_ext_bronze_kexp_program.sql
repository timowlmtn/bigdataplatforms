
--------------------------------------- KEXP_PROGRAM
create or replace stage STAGE.STG_BRONZE_KEXP_PROGRAM
    storage_integration = OWLMTN_S3_DATA
    url = 's3://owlmtn-stage-data/stage/kexp/delta/bronze/KEXP_PROGRAM';
    
list @STAGE.STG_BRONZE_KEXP_PROGRAM;

create or replace external table STAGE.EXT_BRONZE_KEXP_PROGRAM(
description string as (value:description::string)
    , id integer as (value:id::integer)
    , is_active boolean as (value:is_active::boolean)
    , name string as (value:name::string)
    , tags string as (value:tags::string)
    , uri string as (value:uri::string)
    , bronze_source string as (value:bronze_source::string)
    , bronze_created_timestamp timestamp as (value:bronze_created_timestamp::timestamp)
    , bronze_modified_timestamp timestamp as (value:bronze_modified_timestamp::timestamp))
  location=@STAGE.STG_BRONZE_KEXP_PROGRAM
  auto_refresh = false
  refresh_on_create = false
  file_format = (type = parquet)
  table_format = delta;
    
alter external table STAGE.EXT_BRONZE_KEXP_PROGRAM refresh;

select * from STAGE.EXT_BRONZE_KEXP_PROGRAM;
