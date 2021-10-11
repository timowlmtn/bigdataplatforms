create or replace view stage.KEXP_SHOW_FAVORITES
as
with favs as (
select SHOW_ID, song, ARTIST,
       date_part(year, start_time) || date_part(weekofyear, START_TIME) week_id,
       count(AIRDATE) over (partition by song, artist order by program_name, date_part(weekofyear, start_time)) window_fun,
       airdate,
       host_names, program_name
from stage.KEXP_PLAYLIST_SHOW
where PROGRAM_NAME = 'The Midday Show' and song is not null
and AIRDATE > dateadd(day, -30, current_date) )
select *
from favs where window_fun > 1
order by window_fun desc, song, artist, SHOW_ID;

grant select on stage.KEXP_SHOW_FAVORITES to role KEXP_READER_ACCESS;