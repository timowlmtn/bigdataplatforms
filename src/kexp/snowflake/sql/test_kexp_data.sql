select *
from STAGE.IMPORT_KEXP_PLAYLIST
order by PLAYLIST_ID desc;

select *
from WAREHOUSE.FACT_KEXP_PLAYLIST
order by playlist_key desc;

select *
from STAGE.RAW_KEXP_PLAYLIST;