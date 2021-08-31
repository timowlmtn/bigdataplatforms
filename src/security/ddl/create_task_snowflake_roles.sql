CREATE or replace TASK admin.create_snapshot_roles
  WAREHOUSE = COMPUTE_WH
  SCHEDULE = 'USING CRON 0 9-17 * * SUN-SAT America/New_York'
AS
call ADMIN.SNAPSHOT_ROLES();

select * from ADMIN.SNOWFLAKE_ROLE;


