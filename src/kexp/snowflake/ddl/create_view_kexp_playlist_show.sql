create or replace view stage.KEXP_PLAYLIST_SHOW
as
with show as (
    select distinct show_id, program_id, program_name, program_tags, host_names, tagline, start_time
    from stage.IMPORT_KEXP_SHOW
)
select distinct PLAYLIST_ID, PLAY_TYPE, AIRDATE, ALBUM, ARTIST, SONG,
       show.SHOW_ID, PROGRAM_ID, PROGRAM_NAME, PROGRAM_TAGS, HOST_NAMES, TAGLINE, START_TIME
from STAGE.IMPORT_KEXP_PLAYLIST plays
left outer join show
    on plays.SHOW_ID = show.SHOW_ID
order by PLAYLIST_ID desc;

grant select on stage.KEXP_PLAYLIST_SHOW to role KEXP_READER_ACCESS;