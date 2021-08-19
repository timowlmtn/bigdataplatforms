call ADMIN.SNAPSHOT_USER_NETWORK_POLICY();

select *
from ADMIN.SNOWFLAKE_USER_NETWORK_POLICY;

CREATE or replace TASK ADMIN.create_snapshot_user_network_policy
  WAREHOUSE = COMPUTE_WH
  SCHEDULE = 'USING CRON 0 9-17 * * SUN-SAT America/New_York'
AS
call ADMIN.SNAPSHOT_USER_NETWORK_POLICY();

show tasks;

alter task ADMIN.create_snapshot_user_network_policy resume;

use warehouse COMPUTE_WH;

select *
    from table(INFORMATION_SCHEMA.task_history(
     result_limit => 10, task_name=>'create_snapshot_user_network_policy'));

