CREATE or replace TASK ADMIN.create_snapshot_user_grant
  WAREHOUSE = COMPUTE_WH
  SCHEDULE = 'USING CRON 0 9-17 * * SUN-SAT America/New_York'
AS
call ADMIN.SNAPSHOT_USER_GRANT();


