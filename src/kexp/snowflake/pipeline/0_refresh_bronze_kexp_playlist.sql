use role ROLE_TIMBURNSDEV;
alter external table STAGE.EXT_BRONZE_KEXP_PLAYLIST refresh;

select BRONZE_CREATED_TIMESTAMP, count(*)
from stage.EXT_BRONZE_KEXP_PLAYLIST
group by BRONZE_CREATED_TIMESTAMP
order by BRONZE_CREATED_TIMESTAMP desc;

describe table stage.kexp_playlist;

select count(*)
from stage.kexp_playlist;