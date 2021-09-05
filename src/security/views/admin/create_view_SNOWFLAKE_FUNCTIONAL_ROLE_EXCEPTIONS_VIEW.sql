create or replace view ADMIN.SNOWFLAKE_FUNCTIONAL_ROLE_EXCEPTIONS_VIEW AS
with access_role as (
    select created_on, role, granted_to, grantee_name, granted_by, dw_create_date, dw_created_by
    from admin.SNOWFLAKE_GRANTS_OF_ROLE
    where granted_to = 'ROLE'
      and  case when length(GRANTED_BY) = 0 then null else GRANTED_BY end is not null
),
functional_role as (
    select created_on, role, granted_to, grantee_name, granted_by, dw_create_date, dw_created_by
    from admin.SNOWFLAKE_GRANTS_OF_ROLE
    where granted_to = 'USER'
      and  case when length(GRANTED_BY) = 0 then null else GRANTED_BY end is not null
    )
select all_roles.ROLE,
       all_roles.GRANTED_TO,
       count(all_roles.GRANTEE_NAME) grantee_count,
       case when length(all_roles.GRANTED_BY) = 0 then null else all_roles.GRANTED_BY end granted_by,
       case when access_role.role is not null then True else False end is_access_role,
       case when access_role.role is not null and all_roles.GRANTED_TO = 'USER'
           then True else False end is_access_exception,
       case when length(all_roles.GRANTED_BY) = 0 and all_roles.GRANTED_TO = 'USER'
            then True else False end is_root_role_exception,
       case when functional_role.role is null and count(all_roles.GRANTEE_NAME) > 0
                and all_roles.GRANTED_TO = 'USER'
            then True else False end is_functional_role_exception
from admin.SNOWFLAKE_GRANTS_OF_ROLE all_roles
left outer join access_role on all_roles.role = access_role.ROLE
left outer join functional_role on all_roles.role = functional_role.role
group by all_roles.ROLE,
         all_roles.GRANTED_TO, all_roles.GRANTED_BY, access_role.role, functional_role.role;

