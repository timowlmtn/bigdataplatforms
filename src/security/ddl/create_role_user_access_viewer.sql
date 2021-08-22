create role if not exists USER_ACCESS_VIEWER ;

grant select on table ADMIN.SNOWFLAKE_USER_GRANT
to role USER_ACCESS_VIEWER;

grant select on table ADMIN.SNOWFLAKE_USER
to role USER_ACCESS_VIEWER;

grant select on table ADMIN.SNOWFLAKE_USER_NETWORK_POLICY
    to role USER_ACCESS_VIEWER;

grant select on table ADMIN.SNOWFLAKE_LOGIN_HISTORY
    to role USER_ACCESS_VIEWER;
