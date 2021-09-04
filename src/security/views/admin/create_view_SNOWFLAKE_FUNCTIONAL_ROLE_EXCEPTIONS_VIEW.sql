create or replace view ADMIN.SNOWFLAKE_FUNCTIONAL_ROLE_EXCEPTIONS_VIEW AS
select created_on, role, granted_to, grantee_name, granted_by, dw_create_date, dw_created_by
from admin.SNOWFLAKE_GRANTS_OF_ROLE
where granted_to = 'ROLE'
  and  case when length(GRANTED_BY) = 0 then null else GRANTED_BY end is not null;



select created_on, role, granted_to, grantee_name, granted_by, dw_create_date, dw_created_by
from admin.SNOWFLAKE_GRANTS_OF_ROLE
where granted_to = 'ROLE'
  and  case when length(GRANTED_BY) = 0 then null else GRANTED_BY end is not null;

select created_on, role, granted_to, grantee_name, granted_by, dw_create_date, dw_created_by
from admin.SNOWFLAKE_GRANTS_OF_ROLE
where granted_to <> 'ROLE'
  or case when length(GRANTED_BY) = 0 then null else GRANTED_BY end is null;


select *
from admin.SNOWFLAKE_ROLE_GRANT


