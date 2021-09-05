create or replace view ADMIN.SNOWFLAKE_FUNCTIONAL_ROLE_EXCEPTIONS_VIEW AS
with functional_role_summary as (
    select all_roles.role,
           all_roles.granted_to,
           count(all_roles.grantee_name) grantee_count
    from admin.SNOWFLAKE_GRANTS_OF_ROLE all_roles
    where length(GRANTED_BY) > 0 and GRANTED_TO = 'ROLE'
    group by all_roles.role, all_roles.granted_to
),
     access_role_direct as (
        select all_roles.role,
           all_roles.granted_to,
           count(all_roles.grantee_name) grantee_count
        from admin.SNOWFLAKE_GRANTS_OF_ROLE all_roles
        where length(GRANTED_BY) > 0 and GRANTED_TO = 'USER'
        group by all_roles.role, all_roles.granted_to
),
     access_grant_summary as (
         select role, GRANTED_TO, GRANTED_BY, count(PRIVILEGE) non_role_grants
         from admin.SNOWFLAKE_ROLE_GRANT role_grant
         where granted_on <> 'ROLE'
         group by role_grant.role, role_grant.GRANTED_BY, role_grant.granted_to
     )
select all_roles.role,
       all_roles.GRANTED_TO,
       functional_role_summary.grantee_count,
       access_grant_summary.non_role_grants,
       length(all_roles.GRANTED_BY) = 0     is_system_role,
       case
           when length(all_roles.GRANTED_BY) = 0 and all_roles.GRANTED_TO = 'USER'
               then True
           else False end                   is_system_role_exception,
       access_grant_summary.role is not null is_access_role,
       access_role_direct.role is not null is_access_role_exception
from admin.SNOWFLAKE_GRANTS_OF_ROLE all_roles
    left outer join functional_role_summary on all_roles.ROLE = functional_role_summary.role
         left outer join access_grant_summary on all_roles.ROLE = access_grant_summary.role
    left outer join access_role_direct on all_roles.ROLE = access_role_direct.role;

