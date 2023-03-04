select count(*);

select date_part(year, RELEASE_DATE::date), max(ARTIST), max(SONG), count(*)
from ANALYTICS.VIEW_KEXP_PLAYLIST_SHOW
group by date_part(year, RELEASE_DATE::date)
order by date_part(year, RELEASE_DATE::date);