create or replace view stage.KEXP_PLAYLIST_SHOW
as
with show as (
    select distinct SHOW_ID, HOST_NAMES, PROGRAM_NAME, PROGRAM_TAGS, START_TIME
    from stage.IMPORT_KEXP_SHOW
)
select AIRDATE, SONG, ARTIST, show.*
from STAGE.IMPORT_KEXP_PLAYLIST plays
left outer join show
    on plays.SHOW_ID = show.SHOW_ID
order by PLAYLIST_ID desc;

grant select on stage.KEXP_PLAYLIST_SHOW to role KEXP_READER_ACCESS;