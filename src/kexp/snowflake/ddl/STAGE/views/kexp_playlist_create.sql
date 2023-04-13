use role APPADMIN;

create or replace view stage.kexp_playlist
as
select VALUE,
       AIRDATE,
       ALBUM,
       ARTIST,
       ARTIST_IDS,
       COMMENT,
       ID,
       IMAGE_URI,
       IS_LIVE,
       IS_LOCAL,
       IS_REQUEST,
       LABEL_IDS,
       LABELS,
       PLAY_TYPE,
       RECORDING_ID,
       RELEASE_DATE,
       RELEASE_GROUP_ID,
       RELEASE_ID,
       ROTATION_STATUS,
       SHOW,
       SHOW_URI,
       SONG,
       THUMBNAIL_URI,
       TRACK_ID,
       URI,
       1 PLAY_COUNT,
       BRONZE_SOURCE,
       BRONZE_CREATED_TIMESTAMP,
       BRONZE_MODIFIED_TIMESTAMP
from stage.EXT_BRONZE_KEXP_PLAYLIST;

grant select on all views in schema STAGE to role ANALYTICS;