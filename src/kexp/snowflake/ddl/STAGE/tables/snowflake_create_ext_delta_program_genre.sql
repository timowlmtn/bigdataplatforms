
--------------------------------------- PROGRAM_GENRE
create or replace stage STAGE.STG_SILVER_PROGRAM_GENRE
    storage_integration = OWLMTN_S3_DATA
    url = 's3://owlmtn-stage-data/stage/kexp/delta/silver/PROGRAM_GENRE';
    
list @STAGE.STG_SILVER_PROGRAM_GENRE;

create or replace external table STAGE.EXT_SILVER_PROGRAM_GENRE(genre string as (value:genre::string), program_id integer as (value:program_id::integer), silver_source string as (value:silver_source::string), silver_created_timestamp timestamp as (value:silver_created_timestamp::timestamp), silver_modified_timestamp timestamp as (value:silver_modified_timestamp::timestamp))
  location=@STAGE.STG_SILVER_PROGRAM_GENRE
  auto_refresh = false
  refresh_on_create = false
  file_format = (type = parquet)
  table_format = delta;
    
alter external table STAGE.EXT_SILVER_PROGRAM_GENRE refresh;

select * from STAGE.EXT_SILVER_PROGRAM_GENRE;
