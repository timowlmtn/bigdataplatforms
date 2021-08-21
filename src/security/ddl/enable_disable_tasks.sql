use schema admin;

show tasks;


select *
    from table(INFORMATION_SCHEMA.task_history(
     result_limit => 10));



alter task ADMIN.APPEND_SNOWFLAKE_LOGIN_HISTORY resume;

alter task ADMIN.APPEND_SNOWFLAKE_LOGIN_HISTORY suspend;

select * from  ADMIN.SNOWFLAKE_LOGIN_HISTORY

show tasks;
drop task CREATE_SNAPSHOT_USER;

drop task CREATE_SNAPSHOT_USER_GRANTS;

alter task CREATE_SNAPSHOT_USERS suspend;
alter task CREATE_SNAPSHOT_USER_GRANT suspend;