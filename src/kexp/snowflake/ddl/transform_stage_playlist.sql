insert into WAREHOUSE.fact_kexp_playlist(LOAD_ID, PLAYLIST_ID, PLAY_TYPE, AIRDATE, ALBUM, ARTIST, SONG, SHOW_ID)
select stg.load_id,
       stg.value:id::Int,
       stg.value:play_type::String,
       stg.value:airdate::TIMESTAMP_LTZ,
       stg.value:album::String,
       stg.value:artist::String,
       stg.value:song::String,
       stg.value:show::INT
from stage.raw_kexp_playlist stg
left outer join WAREHOUSE.fact_kexp_playlist existing on value:id::INT = existing.playlist_id
where stg.load_id > (select coalesce(max(load_id), 0) from WAREHOUSE.FACT_KEXP_PLAYLIST);
