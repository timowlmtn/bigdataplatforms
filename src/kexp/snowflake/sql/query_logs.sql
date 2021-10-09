select
       $1:airdate_after_date airdate_after_date,
       $1:airdate_before_date airdate_before_date,
       $1:playlist_key::STRING PLAYLIST_KEY,
       $1:shows_key::STRING SHOWS_KEY,
       $1:number_songs::INT NUMBER_SONGS,
       metadata$filename                filename
from @owlmtn.stage.KEXP_PUBLIC (
         pattern =>'stage/kexp/logs/.*',
         file_format => stage.json_file_format) stg
order by airdate_before_date;


select
       min($1:airdate_after_date),
       min($1:airdate_before_date),
       max($1:airdate_after_date),
       max($1:airdate_before_date),
       count($1:playlist_key::STRING),
       count($1:shows_key::STRING),
       sum($1:number_songs::INT)
from @owlmtn.stage.KEXP_PUBLIC (
         pattern =>'stage/kexp/logs/.*',
         file_format => stage.json_file_format) stg;