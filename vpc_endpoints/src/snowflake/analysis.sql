select system$get_snowflake_platform_info();

desc integration STORAGE_INTEGRATION_ACME_CUSTOMER;

list @SIMPLE_STAGE;

select *
from @SIMPLE_STAGE
         (file_format => JSON_FORMAT) t;

copy into SIMPLE_TABLE (ID,
                        NAME,
                        VALUE,
                        DW_FILENAME,
                        DW_FILE_ROW_NUMBER)
    from (select $1:ID::integer    id
               , $1:Name::string name
               , $1:Value::string value
               , metadata$filename
               , metadata$file_row_number
          from @SIMPLE_STAGE)
    file_format = (type = json);

select *
from simple_table;