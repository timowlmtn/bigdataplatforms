
--------------------------------------- SHOW
create or replace stage STAGE.STG_SILVER_SHOW
    storage_integration = OWLMTN_S3_DATA
    url = 's3://owlmtn-stage-data/stage/kexp/delta/silver/SHOW';
    
list @STAGE.STG_SILVER_SHOW;

create or replace external table STAGE.EXT_SILVER_SHOW(id integer as (value:id::integer), image_uri string as (value:image_uri::string), program integer as (value:program::integer), program_name string as (value:program_name::string), program_tags string as (value:program_tags::string), program_uri string as (value:program_uri::string), start_time timestamp as (value:start_time::timestamp), tagline string as (value:tagline::string), uri string as (value:uri::string), silver_source string as (value:silver_source::string), silver_created_timestamp timestamp as (value:silver_created_timestamp::timestamp), silver_modified_timestamp timestamp as (value:silver_modified_timestamp::timestamp))
  location=@STAGE.STG_SILVER_SHOW
  auto_refresh = false
  refresh_on_create = false
  file_format = (type = parquet)
  table_format = delta;
    
alter external table STAGE.EXT_SILVER_SHOW refresh;

select * from STAGE.EXT_SILVER_SHOW;
