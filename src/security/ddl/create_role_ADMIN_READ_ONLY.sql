/**
  The Admin Read Only role is a functional role to read all the tables and views  in the ADMIN schema.
 */
create role ADMIN_READ_ONLY;

 select 'grant select on '|| table_name || ' to role ADMIN_READ_ONLY;' sql_statement
from information_schema.tables where table_schema = 'ADMIN'
union all
 select 'grant select on '|| TABLE_NAME || ' to role ADMIN_READ_ONLY;' sql_statement
from information_schema.VIEWS where table_schema = 'ADMIN';

-- Output here
grant select on SNOWFLAKE_LOGIN_HISTORY to role ADMIN_READ_ONLY;
grant select on SNOWFLAKE_ROLE to role ADMIN_READ_ONLY;
grant select on SNOWFLAKE_ROLE_GRANT to role ADMIN_READ_ONLY;
grant select on SNOWFLAKE_USER to role ADMIN_READ_ONLY;
grant select on SNOWFLAKE_USER_AUTHENTICATION_VIEW to role ADMIN_READ_ONLY;
grant select on SNOWFLAKE_USER_AUTHORIZATION_SUMMARY_VIEW to role ADMIN_READ_ONLY;
grant select on SNOWFLAKE_USER_AUTHORIZATION_VIEW to role ADMIN_READ_ONLY;
grant select on SNOWFLAKE_USER_GRANT to role ADMIN_READ_ONLY;
grant select on SNOWFLAKE_USER_NETWORK_POLICY to role ADMIN_READ_ONLY;

grant select on SNOWFLAKE_USER_AUTHENTICATION_VIEW to role ADMIN_READ_ONLY;
grant select on SNOWFLAKE_USER_AUTHORIZATION_SUMMARY_VIEW to role ADMIN_READ_ONLY;
grant select on SNOWFLAKE_USER_AUTHORIZATION_VIEW to role ADMIN_READ_ONLY;
