
--------------------------------------- PLAYLIST
create or replace stage STAGE.STG_SILVER_PLAYLIST
    storage_integration = OWLMTN_S3_DATA
    url = 's3://owlmtn-stage-data/stage/kexp/delta/silver/PLAYLIST';
    
list @STAGE.STG_SILVER_PLAYLIST;

create or replace external table STAGE.EXT_SILVER_PLAYLIST(airdate timestamp as (value:airdate::timestamp), album string as (value:album::string), artist string as (value:artist::string), comment string as (value:comment::string), id integer as (value:id::integer), image_uri string as (value:image_uri::string), is_live boolean as (value:is_live::boolean), is_local boolean as (value:is_local::boolean), is_request boolean as (value:is_request::boolean), play_type string as (value:play_type::string), recording_id integer as (value:recording_id::integer), release_date date as (value:release_date::date), release_group_id integer as (value:release_group_id::integer), release_id integer as (value:release_id::integer), rotation_status string as (value:rotation_status::string), show integer as (value:show::integer), show_uri string as (value:show_uri::string), song string as (value:song::string), thumbnail_uri string as (value:thumbnail_uri::string), track_id integer as (value:track_id::integer), uri string as (value:uri::string), silver_source string as (value:silver_source::string), silver_created_timestamp timestamp as (value:silver_created_timestamp::timestamp), silver_modified_timestamp timestamp as (value:silver_modified_timestamp::timestamp))
  location=@STAGE.STG_SILVER_PLAYLIST
  auto_refresh = false
  refresh_on_create = false
  file_format = (type = parquet)
  table_format = delta;
    
alter external table STAGE.EXT_SILVER_PLAYLIST refresh;

select * from STAGE.EXT_SILVER_PLAYLIST;
