CREATE or replace TASK admin.create_snapshot_user
  WAREHOUSE = COMPUTE_WH
  SCHEDULE = 'USING CRON 0 9-17 * * SUN-SAT America/New_York'
AS
call ADMIN.SNAPSHOT_USERS();


show tasks;

alter task admin.create_snapshot_user resume;



