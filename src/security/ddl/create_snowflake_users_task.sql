USE SCHEMA STAGE;
USE ROLE ACCOUNTADMIN;


use role ACCOUNTADMIN;

call STAGE.SNAPSHOT_USERS();

CREATE or replace TASK create_snapshot_users
  WAREHOUSE = LOAD_WH
  SCHEDULE = 'USING CRON 0 9-17 * * MON-FRI America/New_York'
AS
call STAGE.SNAPSHOT_USERS();

show tasks;

alter task create_snapshot_users resume;

use warehouse LOAD_WH;

select *
    from table(INFORMATION_SCHEMA.task_history(
     result_limit => 10, task_name=>'create_snapshot_users'));


select * from STAGE.SNOWFLAKE_USERS;

use role APPADMIN;
select * from STAGE.snowflake_users;