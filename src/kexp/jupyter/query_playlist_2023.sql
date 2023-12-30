with kexp_live_artists_last_year as (
-- LANDING_ZONE.VIEW_KEXP_PLAYLIST_SHOW
    select lower(replace(ARTIST, '&', 'and')) ARTIST, min(AIRDATE) first_airdate
    from LANDING_ZONE.VIEW_KEXP_PLAYLIST_SHOW
    where date_part(year, AIRDATE) >= 2022 and date_part(year, AIRDATE) < 2023
      and PROGRAM_NAME = 'Live on KEXP'
      and ALBUM like '%Live on KEXP%'
      and ARTIST is not null
--       and artist = 'CHVRCHES'
--       and artist = 'The Mountain Goats'
--       and artist = 'King Gizzard and the Lizard Wizard'
    group by 1
    --
    )
select weekofyear(show.AIRDATE)       week_number,
--        weekofyear(live.first_airdate) week_number_live_show,
       live.ARTIST,
--        song,
       count(distinct show.AIRDATE)   play_count,
       iff(year(show.AIRDATE) = 2022, 0, 1) * play_count
                                      last_year_play_count,
       iff(year(show.AIRDATE) = 2023, 0, 1) * play_count
                                      this_year_play_count
from kexp_live_artists_last_year live
         inner join LANDING_ZONE.VIEW_KEXP_PLAYLIST_SHOW show
                    on live.ARTIST =
                       lower(replace(show.ARTIST, '&', 'and'))
    and year(show.AIRDATE) >= 2022 and year(show.AIRDATE) < 2024
group by 1, 2, year(show.AIRDATE)
order by 1, 2, 3
;