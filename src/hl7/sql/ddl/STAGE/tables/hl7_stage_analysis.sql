show stages;

-- List the stage files
list @stage.HL7_STG;

-- Get the counts
select STAGE_FILENAME, count(*)
from STAGE.CMS_PROVIDER
group by STAGE_FILENAME;

show file formats ;

-- Query the data structure
select t."$1":msh:"none"[0]:varies_1:st::string last_name
    , t."$1":msh:"none"[0]:varies_2:st::string first_name
    , t."$1":msh:"none"
    , $1
from @stage.HL7_STG (
    file_format => stage.JSON_FILE_FORMAT,
    pattern => '.*.json'
    ) t;

