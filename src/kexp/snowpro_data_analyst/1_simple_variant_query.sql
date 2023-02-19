--- Check to see the stages you can query
-- If none, then see this article: https://medium.com/snowflake/securing-the-snowflake-storage-integration-on-aws-21046672f1a8
show stages;

--- Show what is in the storage location
list @STAGE.KEXP_PUBLIC;

--- Narrow down to specific files you would like to view, for example Feb 7, 2023, International Clash Day
--- This shows logs, playlists and shows for international Clash Data
list @STAGE.KEXP_PUBLIC
    pattern = '.*20230207.*';



--- View the structure of the data object using a variant structure
select
       $1,
       metadata$filename                filename
from @owlmtn.stage.KEXP_PUBLIC (
         pattern =>'stage/kexp/logs/20230207/api20230207.*',
         file_format => stage.json_file_format) stg
order by metadata$filename desc;

