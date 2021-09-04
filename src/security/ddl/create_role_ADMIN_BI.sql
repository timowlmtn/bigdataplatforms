
create role ADMIN_BI;

show grants to role ADMIN_READ_ONLY;

grant role ADMIN_READ_ONLY to role ADMIN_BI;
grant role ADMIN_BI to USER METABASE_SNOWFLAKE_SECURITY;