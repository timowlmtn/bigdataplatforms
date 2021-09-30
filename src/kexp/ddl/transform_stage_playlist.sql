insert into WAREHOUSE.fact_kexp_playlist(LOAD_ID, PLAY_TYPE, AIRDATE, ALBUM, ARTIST, SONG)
select load_id,
       tab.value:play_type::String,
       tab.value:airdate::TIMESTAMP_LTZ,
       tab.value:album::String,
       tab.value:artist::String,
       tab.value:song::String
from stage.KEXP_PLAYLIST stg,
     table (flatten(stg.value:results)) tab
where load_id > (select coalesce(max(load_id), 0) from WAREHOUSE.FACT_KEXP_PLAYLIST);
