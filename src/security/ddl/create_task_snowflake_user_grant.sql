call ADMIN.SNAPSHOT_USER_GRANT();

select *
from ADMIN.SNOWFLAKE_USER_GRANT;

CREATE or replace TASK ADMIN.create_snapshot_user_grant
  WAREHOUSE = COMPUTE_WH
  SCHEDULE = 'USING CRON 0 9-17 * * SUN-SAT America/New_York'
AS
call ADMIN.SNAPSHOT_USER_GRANT();

show tasks;

alter task create_snapshot_user_grant resume;

use warehouse COMPUTE_WH;

select *
    from table(INFORMATION_SCHEMA.task_history(
     result_limit => 10, task_name=>'create_snapshot_user_grant'));

