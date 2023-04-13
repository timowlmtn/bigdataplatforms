use role APPADMIN;

--------------------------------------- KEXP_PLAYLIST
create or replace stage STAGE.STG_BRONZE_KEXP_PLAYLIST
    storage_integration = OWLMTN_S3_DATA
    url = 's3://owlmtn-stage-data/stage/kexp/delta/bronze/KEXP_PLAYLIST/';

list @STAGE.STG_BRONZE_KEXP_PLAYLIST;

create or replace external table STAGE.EXT_BRONZE_KEXP_PLAYLIST(
    airdate timestamp as (value:airdate::timestamp),
    album string as (value:album::string),
    artist string as (value:artist::string),
    artist_ids variant as (value:artist_ids),
    comment string as (value:comment::string),
    id integer as (value:id::integer),
    image_uri string as (value:image_uri::string),
    is_live boolean as (value:is_live::boolean),
    is_local boolean as (value:is_local::boolean),
    is_request boolean as (value:is_request::boolean),
    label_ids variant as (value:label_ids),
    labels variant as (value:labels),
    play_type string as (value:play_type::string),
    recording_id integer as (value:recording_id::integer),
    release_date date as (value:release_date::date),
    release_group_id integer as (value:release_group_id::integer),
    release_id integer as (value:release_id::integer),
    rotation_status string as (value:rotation_status::string),
    show integer as (value:show::integer),
    show_uri string as (value:show_uri::string),
    song string as (value:song::string),
    thumbnail_uri string as (value:thumbnail_uri::string),
    track_id integer as (value:track_id::integer),
    uri string as (value:uri::string),
    bronze_source string as (value:bronze_source::string),
    bronze_created_timestamp timestamp as (value:bronze_created_timestamp::timestamp),
    bronze_modified_timestamp timestamp as (value:bronze_modified_timestamp::timestamp)
    )
  location=@STAGE.STG_BRONZE_KEXP_PLAYLIST
  auto_refresh = false
  refresh_on_create = false
  file_format = (type = parquet)
  table_format = delta;

alter external table STAGE.EXT_BRONZE_KEXP_PLAYLIST refresh;

select BRONZE_CREATED_TIMESTAMP, count(*)
from STAGE.EXT_BRONZE_KEXP_PLAYLIST
group by BRONZE_CREATED_TIMESTAMP
order by BRONZE_CREATED_TIMESTAMP desc;
