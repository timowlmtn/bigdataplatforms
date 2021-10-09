select *
from STAGE.IMPORT_KEXP_PLAYLIST
order by PLAYLIST_ID desc;

with show as (
    select distinct SHOW_ID, HOST_NAMES, PROGRAM_NAME
    from stage.IMPORT_KEXP_SHOW
)
select AIRDATE, SONG, ARTIST, show.PROGRAM_NAME, show.HOST_NAMES, plays.FILENAME
from STAGE.IMPORT_KEXP_PLAYLIST plays
left outer join show
    on plays.SHOW_ID = show.SHOW_ID
order by PLAYLIST_ID desc;

select *
from WAREHOUSE.FACT_KEXP_PLAYLIST
order by playlist_key desc;

select *
from STAGE.RAW_KEXP_PLAYLIST;