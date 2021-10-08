select metadata$filename                filename,
       metadata$file_row_number row_number,
       $1:airdate_after_date::TIMESTAMP_LTZ airdate_after_date,
       $1:airdate_before_date::TIMESTAMP_LTZ airdate_before_date,
       $1:playlist_key::STRING PLAYLIST_KEY,
       $1:shows_key::STRING SHOWS_KEY
from @owlmtn.stage.KEXP_PUBLIC (
         pattern =>'stage/kexp/logs/.*',
         file_format => stage.json_file_format) stg
order by airdate_before_date desc;