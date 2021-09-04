/**
  The Admin Read Only role is a functional role to read all the tables and views  in the ADMIN schema.
 */
create or replace role ADMIN_READ_ONLY;

 select 'grant select on '|| table_name || ' to role ADMIN_READ_ONLY;' sql_statement
from information_schema.tables where table_schema = 'ADMIN'
union all
 select 'grant select on '|| TABLE_NAME || ' to role ADMIN_READ_ONLY;' sql_statement
from information_schema.VIEWS where table_schema = 'ADMIN';

-- Output here
grant select on ADMIN.SNOWFLAKE_LOGIN_HISTORY to role ADMIN_READ_ONLY;
grant select on ADMIN.SNOWFLAKE_ROLE to role ADMIN_READ_ONLY;
grant select on ADMIN.SNOWFLAKE_ROLE_GRANT to role ADMIN_READ_ONLY;
grant select on ADMIN.SNOWFLAKE_USER to role ADMIN_READ_ONLY;
grant select on ADMIN.SNOWFLAKE_USER_AUTHENTICATION_VIEW to role ADMIN_READ_ONLY;
grant select on ADMIN.SNOWFLAKE_USER_AUTHORIZATION_SUMMARY_VIEW to role ADMIN_READ_ONLY;
grant select on ADMIN.SNOWFLAKE_USER_AUTHORIZATION_VIEW to role ADMIN_READ_ONLY;
grant select on ADMIN.SNOWFLAKE_USER_GRANT to role ADMIN_READ_ONLY;
grant select on ADMIN.SNOWFLAKE_USER_NETWORK_POLICY to role ADMIN_READ_ONLY;

grant select on ADMIN.NOWFLAKE_USER_AUTHENTICATION_VIEW to role ADMIN_READ_ONLY;
grant select on ADMIN.SNOWFLAKE_USER_AUTHORIZATION_SUMMARY_VIEW to role ADMIN_READ_ONLY;
grant select on ADMIN.SNOWFLAKE_USER_AUTHORIZATION_VIEW to role ADMIN_READ_ONLY;
grant select on ADMIN.SNOWFLAKE_GRANTS_OF_ROLE to role ADMIN_READ_ONLY;

grant select on ADMIN.SNOWFLAKE_ROLE_GRANTS_OF_ROLE_VIEW to role ADMIN_READ_ONLY;

grant role ADMIN_READ_ONLY to user METABASE_SNOWFLAKE_SECURITY;

grant usage on database OWLMTN to role ADMIN_READ_ONLY;
grant usage on schema ADMIN to role ADMIN_READ_ONLY;
grant usage on warehouse COMPUTE_WH to role ADMIN_READ_ONLY;


grant role ADMIN_READ_ONLY to role USER_ACCESS_VIEWER;

