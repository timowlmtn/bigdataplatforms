

use role ACCOUNTADMIN;
select parse_json(SYSTEM$GET_PRIVATELINK_CONFIG());

select system$get_snowflake_platform_info();

desc integration STORAGE_INTEGRATION_ACME_CUSTOMER;

use role APPADMIN;
use schema STAGE;
list @SIMPLE_STAGE;

create storage integration s3_int
  type = external_stage
  storage_provider = 'S3'
  storage_aws_role_arn = 'arn:aws:iam::001234567890:role/myrole'
  enabled = true
  storage_allowed_locations = ('*')
  storage_blocked_locations = ('s3://mybucket3/path3/', 's3://mybucket4/path4/');

drop storage integration s3_int

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


use role APPADMIN;

describe user "tf-snow";