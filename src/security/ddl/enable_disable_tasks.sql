use schema admin;

show tasks;


select *
    from table(INFORMATION_SCHEMA.task_history(
     result_limit => 10));


alter task ADMIN.SNAPSHOT_USER_NETWORK_POLICY suspend;

alter task ADMIN.APPEND_SNOWFLAKE_LOGIN_HISTORY resume;

select * from admin.SNOWFLAKE_LOGIN_HISTORY;

alter task ADMIN.APPEND_SNOWFLAKE_LOGIN_HISTORY suspend;

select * from  ADMIN.SNOWFLAKE_LOGIN_HISTORY

alter task ADMIN.APPEND_SNOWFLAKE_LOGIN_HISTORY suspend;

show tasks;
drop task CREATE_SNAPSHOT_USER;

drop task CREATE_SNAPSHOT_USER_GRANTS;

alter task CREATE_SNAPSHOT_USERsuspend;
alter task CREATE_SNAPSHOT_USER_GRANT suspend;