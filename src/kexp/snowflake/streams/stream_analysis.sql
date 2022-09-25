select count(*)
from  STAGE.STREAM_IMPORT_KEXP_PLAYLIST_CDC;

select count(*)
from  STAGE.STREAM_IMPORT_KEXP_SHOW_CDC;

select *
from  STAGE.STREAM_IMPORT_KEXP_SHOW_CDC;

select *
from  STAGE.STREAM_IMPORT_KEXP_PLAYLIST_CDC;


select *
from WAREHOUSE.DIM_KEXP_SHOW
order by start_time desc;

select *
from WAREHOUSE.FACT_KEXP_PLAYLIST
order by AIRDATE desc;