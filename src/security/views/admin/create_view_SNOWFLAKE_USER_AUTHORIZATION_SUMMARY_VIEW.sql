create or replace view ADMIN.SNOWFLAKE_USER_AUTHORIZATION_SUMMARY_VIEW as
with auth_summary as (
    select user_name,
           rg.role,
           sum(OWNERSHIP_PRIVILEDGE) OWNERSHIP_PRIVILEDGE,
           sum(CREATE_PRIVILEDGE)    CREATE_PRIVILEDGE,
           sum(MODIFY_PRIVILEDGE)    MODIFY_PRIVILEDGE,
           sum(APPLY_PRIVILEDGE)     APPLY_PRIVILEDGE,
           sum(EXECUTE_PRIVILEDGE)   EXECUTE_PRIVILEDGE,
           sum(OPERATE_PRIVILEDGE)   OPERATE_PRIVILEDGE,
           sum(PURCHASE_PRIVILEDGE)  PURCHASE_PRIVILEDGE,
           sum(MONITOR_PRIVILEDGE)   MONITOR_PRIVILEDGE
    from ADMIN.SNOWFLAKE_USER_AUTHORIZATION_VIEW u
    left outer join admin.SNOWFLAKE_USER_GRANT rg
        on u.USER_NAME = rg.GRANTEE_NAME and rg.ROLE = 'ACCOUNTADMIN'
    group by user_name, rg.role
)
select u.user_name,
       case when ROLE is not null
           then True else False end SUPER_USER,
       case when OWNERSHIP_PRIVILEDGE > 0 then True else False end ADMIN_USER,
       case
           when (
                   CREATE_PRIVILEDGE > 0
                       or MODIFY_PRIVILEDGE > 0
                       or APPLY_PRIVILEDGE > 0
                       or EXECUTE_PRIVILEDGE > 0
                       or OPERATE_PRIVILEDGE > 0
                       or PURCHASE_PRIVILEDGE > 0
                       or MONITOR_PRIVILEDGE > 0) then True
           else False end                                          POWER_USER,
       case
           when (
                   OWNERSHIP_PRIVILEDGE = 0
                   and CREATE_PRIVILEDGE = 0
                   and MODIFY_PRIVILEDGE = 0
                   and APPLY_PRIVILEDGE = 0
                   and EXECUTE_PRIVILEDGE = 0
                   and OPERATE_PRIVILEDGE = 0
                   and PURCHASE_PRIVILEDGE = 0
                   and MONITOR_PRIVILEDGE = 0) then True
           else False end READ_ONLY_USER
from auth_summary u
;


select * from admin.SNOWFLAKE_USER_AUTHORIZATION_SUMMARY_VIEW;
