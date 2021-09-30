--create or replace table tab_atkins_recipes as

show stages;
use schema stage;

list @STAGE.AZRIUS_STAGE_TEST pattern='stage/kexp/.*';

select tab.value:airdate,
       tab.value:album,
       tab.value:artist,
       tab.value:song,
       tab.value,
       stg."$1":results,
       metadata$filename filename,
       metadata$file_row_number
from @owlmtn.stage.AZRIUS_STAGE_TEST (
                        pattern =>'stage/kexp/.*',
                        file_format => stage.json_file_format) stg,
     table(flatten(stg.$1:results)) tab;


     ,
     table(flatten((s.$1:results))) t;
