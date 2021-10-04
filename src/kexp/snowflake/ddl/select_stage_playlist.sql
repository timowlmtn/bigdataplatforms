select tab.value:play_type::STRING play_type,
       tab.value:airdate::TIMESTAMP_LTZ airdate,
       tab.value:album::STRING album,
       tab.value:artist::STRING artist,
       tab.value:song::STRING song,
       tab.value,
       stg."$1":results,
       metadata$filename filename,
       metadata$file_row_number
from @owlmtn.stage.AZRIUS_STAGE_TEST (
                        pattern =>'stage/kexp/.*',
                        file_format => stage.json_file_format) stg,
     table(flatten(stg.$1:results)) tab;