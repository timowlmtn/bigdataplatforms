
--------------------------------------- KEXP_SHOW
create or replace stage STAGE.STG_BRONZE_KEXP_SHOW
    storage_integration = OWLMTN_S3_DATA
    url = 's3://owlmtn-stage-data/stage/kexp/delta/bronze/KEXP_SHOW';
    
list @STAGE.STG_BRONZE_KEXP_SHOW;

create or replace external table STAGE.EXT_BRONZE_KEXP_SHOW(
host_names variant as (value:host_names::variant)
    , host_uris variant as (value:host_uris::variant)
    , hosts variant as (value:hosts::variant)
    , id integer as (value:id::integer)
    , image_uri string as (value:image_uri::string)
    , program integer as (value:program::integer)
    , program_name string as (value:program_name::string)
    , program_tags string as (value:program_tags::string)
    , program_uri string as (value:program_uri::string)
    , start_time timestamp as (value:start_time::timestamp)
    , tagline string as (value:tagline::string)
    , uri string as (value:uri::string)
    , bronze_source string as (value:bronze_source::string)
    , bronze_created_timestamp timestamp as (value:bronze_created_timestamp::timestamp)
    , bronze_modified_timestamp timestamp as (value:bronze_modified_timestamp::timestamp))
  location=@STAGE.STG_BRONZE_KEXP_SHOW
  auto_refresh = false
  refresh_on_create = false
  file_format = (type = parquet)
  table_format = delta;
    
alter external table STAGE.EXT_BRONZE_KEXP_SHOW refresh;

select * from STAGE.EXT_BRONZE_KEXP_SHOW;
