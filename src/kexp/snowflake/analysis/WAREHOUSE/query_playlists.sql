select
       $1,
       metadata$filename                filename
from @owlmtn.stage.KEXP_PUBLIC (
         pattern =>'stage/kexp/playlists/.*',
         file_format => stage.json_file_format) stg
order by metadata$filename desc;

select
       $1,
       metadata$filename                filename
from @owlmtn.stage.KEXP_PUBLIC (
         pattern =>'stage/kexp/shows/.*',
         file_format => stage.json_file_format) stg
order by metadata$filename desc;
