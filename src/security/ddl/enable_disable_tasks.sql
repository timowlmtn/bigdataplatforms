use schema admin;

show tasks;


select *
    from table(INFORMATION_SCHEMA.task_history(
     result_limit => 10));


alter task ADMIN.SNAPSHOT_USER_NETWORK_POLICY suspend;

alter task APPEND_SNOWFLAKE_LOGIN_HISTORY suspend;
alter task CREATE_SNAPSHOT_USER  suspend;
alter task CREATE_SNAPSHOT_USER_GRANT  suspend;
alter task CREATE_SNAPSHOT_USER_NETWORK_POLICY  suspend;

select * from admin.SNOWFLAKE_LOGIN_HISTORY
order by EVENT_TIMESTAMP desc;