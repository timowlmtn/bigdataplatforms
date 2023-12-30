with kexp_live_artists as (
-- LANDING_ZONE.VIEW_KEXP_PLAYLIST_SHOW
    select ARTIST, min(AIRDATE) first_airdate
    from LANDING_ZONE.VIEW_KEXP_PLAYLIST_SHOW
    where date_part(year, AIRDATE) = 2023
      and PROGRAM_NAME = 'Live on KEXP'
      and ALBUM like '%Live on KEXP%'
      and ARTIST is not null
--       and artist = 'King Gizzard and the Lizard Wizard'
    group by 1)
select weekofyear(show.AIRDATE)       week_number,
       weekofyear(live.first_airdate) week_number_live_show,
       show.ARTIST,
       count(distinct show.AIRDATE)   play_count,
       iff(weekofyear(show.AIRDATE) > weekofyear(live.first_airdate), 0, 1) * play_count
                                      play_count_before,
       iff(weekofyear(show.AIRDATE) > weekofyear(live.first_airdate), 1, 0) * play_count
                                      play_count_after


from kexp_live_artists live
         inner join LANDING_ZONE.VIEW_KEXP_PLAYLIST_SHOW show
                    on replace(live.ARTIST, '&', 'and') = replace(show.ARTIST, '&', 'and')
group by weekofyear(show.AIRDATE), 2, 3
order by 1, 2, 3
;