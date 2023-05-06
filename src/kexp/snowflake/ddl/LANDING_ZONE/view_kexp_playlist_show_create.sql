create or replace view LANDING_ZONE.VIEW_KEXP_PLAYLIST_SHOW
as
with show as (select show_id,
                     program_id,
                     program_name,
                     program_tags,
                     host_names,
                     tagline,
                     start_time,
                     max(LANDING_ZONE_UPDATE_DATE) LAST_UPDATED
              from LANDING_ZONE.IMPORT_SHOW
              where SHOW_ID is not null
              group by show_id,
                       program_id,
                       program_name,
                       program_tags,
                       host_names,
                       tagline,
                       start_time)
select PLAYLIST_ID,
       PLAY_TYPE,
       AIRDATE,
       ALBUM,
       ARTIST,
       SONG,
       show.SHOW_ID,
       PROGRAM_ID,
       PROGRAM_NAME,
       PROGRAM_TAGS,
       HOST_NAMES,
       TAGLINE,
       START_TIME,
       try_to_date(RELEASE_DATE, 'YYYY-MM-DD') RELEASE_DATE,
       COMMENT,
       LABELS,
       show.LAST_UPDATED                       show_last_updated,
       max(LANDING_ZONE_UPDATE_DATE)           playlist_last_updated
from LANDING_ZONE.IMPORT_PLAYLIST plays
         left outer join show
                         on plays.SHOW_ID = show.SHOW_ID
group by PLAYLIST_ID,
         PLAY_TYPE,
         AIRDATE,
         ALBUM,
         ARTIST,
         SONG,
         show.SHOW_ID,
         PROGRAM_ID,
         PROGRAM_NAME,
         PROGRAM_TAGS,
         HOST_NAMES,
         TAGLINE,
         START_TIME,
         RELEASE_DATE,
         COMMENT,
         LABELS,
         show.LAST_UPDATED
order by PLAYLIST_ID desc;
