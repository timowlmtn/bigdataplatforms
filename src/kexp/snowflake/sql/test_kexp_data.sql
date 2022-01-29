with show as (
    select distinct SHOW_ID,
                    HOST_NAMES::STRING HOST_NAMES,
                    PROGRAM_NAME,
                    PROGRAM_TAGS,
                    START_TIME
    from stage.IMPORT_KEXP_SHOW
)
select PLAYLIST_ID,
       PLAY_TYPE,
       AIRDATE,
       ALBUM,
       ARTIST,
       SONG,
       show.SHOW_ID,
       HOST_NAMES,
       PROGRAM_NAME,
       PROGRAM_TAGS,
       START_TIME
from STAGE.IMPORT_KEXP_PLAYLIST plays
left outer join show
    on plays.SHOW_ID = show.SHOW_ID
order by PLAYLIST_ID desc;

select airdate
from stage.IMPORT_KEXP_PLAYLIST
;

select *
from STAGE.KEXP_PLAYLIST_SHOW
where AIRDATE = '000';

select try_to_date(RELEASE_DATE, 'YYYY-MM-DD')
from STAGE.IMPORT_KEXP_PLAYLIST;

select *
from stage.KEXP_PLAYLIST_SHOW
where RELEASE_DATE is not null;
