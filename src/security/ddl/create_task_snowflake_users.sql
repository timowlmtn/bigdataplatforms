call ADMIN.SNAPSHOT_USERS();

select *
from ADMIN.SNOWFLAKE_USER;

CREATE or replace TASK admin.create_snapshot_user
  WAREHOUSE = COMPUTE_WH
  SCHEDULE = 'USING CRON 0 9-17 * * SUN-SAT America/New_York'
AS
call ADMIN.SNAPSHOT_USERS();

use schema admin;
show tasks;

alter task create_snapshot_users resume;

use warehouse COMPUTE_WH;

select *
    from table(INFORMATION_SCHEMA.task_history(
     result_limit => 10, task_name=>'create_snapshot_users'));

