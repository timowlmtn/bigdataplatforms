create or replace view ADMIN.SNOWFLAKE_USER_AUTHORIZATION_VIEW as
    select su.name                                                user_name,
           srg.ROLE,
           srg.PRIVILEGE,
           srg.GRANTED_ON,
           srg.name,
           case when PRIVILEGE = 'OWNERSHIP' then 1 else 0 end    OWNERSHIP_PRIVILEDGE,
           case when PRIVILEGE like 'CREATE%' then 1 else 0 end   CREATE_PRIVILEDGE,
           case when PRIVILEGE like 'MODIFY%' then 1 else 0 end   MODIFY_PRIVILEDGE,
           case when PRIVILEGE like 'APPLY%' then 1 else 0 end    APPLY_PRIVILEDGE,
           case when PRIVILEGE like 'EXECUTE%' then 1 else 0 end  EXECUTE_PRIVILEDGE,
           case when PRIVILEGE like 'OPERATE%' then 1 else 0 end  OPERATE_PRIVILEDGE,
           case when PRIVILEGE like 'PURCHASE%' then 1 else 0 end PURCHASE_PRIVILEDGE,
           case when PRIVILEGE like 'MONITOR%' then 1 else 0 end  MONITOR_PRIVILEDGE
    from ADMIN.SNOWFLAKE_ROLE_GRANT srg
             inner join admin.SNOWFLAKE_USER_GRANT sug on srg.role = sug.ROLE
             INNER JOIN ADMIN.SNOWFLAKE_USER su ON SUG.grantee_name = su.name



select * from ADMIN.SNOWFLAKE_USER_AUTHORIZATION;