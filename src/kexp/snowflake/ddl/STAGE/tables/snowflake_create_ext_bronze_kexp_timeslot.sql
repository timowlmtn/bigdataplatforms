
--------------------------------------- KEXP_TIMESLOT
create or replace stage STAGE.STG_BRONZE_KEXP_TIMESLOT
    storage_integration = OWLMTN_S3_DATA
    url = 's3://owlmtn-stage-data/stage/kexp/delta/bronze/KEXP_TIMESLOT/';
    
list @STAGE.STG_BRONZE_KEXP_TIMESLOT;

create or replace external table STAGE.EXT_BRONZE_KEXP_TIMESLOT(
duration string as (value:duration::string)
    , end_date date as (value:end_date::date)
    , end_time string as (value:end_time::string)
    , host_names variant as (value:host_names::variant)
    , host_uris variant as (value:host_uris::variant)
    , hosts variant as (value:hosts::variant)
    , id integer as (value:id::integer)
    , program integer as (value:program::integer)
    , program_name string as (value:program_name::string)
    , program_tags string as (value:program_tags::string)
    , program_uri string as (value:program_uri::string)
    , start_date date as (value:start_date::date)
    , start_time string as (value:start_time::string)
    , uri string as (value:uri::string)
    , weekday integer as (value:weekday::integer)
    , bronze_source string as (value:bronze_source::string)
    , bronze_created_timestamp timestamp as (value:bronze_created_timestamp::timestamp)
    , bronze_modified_timestamp timestamp as (value:bronze_modified_timestamp::timestamp))
  location=@STAGE.STG_BRONZE_KEXP_TIMESLOT
  auto_refresh = false
  refresh_on_create = false
  file_format = (type = parquet)
  table_format = delta;
    
alter external table STAGE.EXT_BRONZE_KEXP_TIMESLOT refresh;

select * from STAGE.EXT_BRONZE_KEXP_TIMESLOT;
