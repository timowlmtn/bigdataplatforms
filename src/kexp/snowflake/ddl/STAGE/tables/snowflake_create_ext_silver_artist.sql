
--------------------------------------- ARTIST
create or replace stage STAGE.STG_SILVER_ARTIST
    storage_integration = OWLMTN_S3_DATA
    url = 's3://owlmtn-stage-data/stage/kexp/delta/silver/ARTIST/';
    
list @STAGE.STG_SILVER_ARTIST;

create or replace external table STAGE.EXT_SILVER_ARTIST(id string as (value:id::string), artist string as (value:artist::string), silver_source string as (value:silver_source::string), silver_created_timestamp timestamp as (value:silver_created_timestamp::timestamp), silver_modified_timestamp timestamp as (value:silver_modified_timestamp::timestamp))
  location=@STAGE.STG_SILVER_ARTIST
  auto_refresh = false
  refresh_on_create = false
  file_format = (type = parquet)
  table_format = delta;
    
alter external table STAGE.EXT_SILVER_ARTIST refresh;

select * from STAGE.EXT_SILVER_ARTIST;
