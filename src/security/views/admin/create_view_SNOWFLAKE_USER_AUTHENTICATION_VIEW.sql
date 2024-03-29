create or replace view ADMIN.SNOWFLAKE_USER_AUTHENTICATION_VIEW AS
with start_mfa as (
    select user_name,
           case when length(np.VALUE) > 0 then np.value else null end POLICY_VALUE,
           np.default POLICY_DEFAULT,
           np.level POLICY_LEVEL,
           np.DESCRIPTION POLICY_DESCRIPTION,
           max(event_timestamp) last_login_event_timestamp
    from admin.SNOWFLAKE_LOGIN_HISTORY lh
    inner join admin.SNOWFLAKE_USER_NETWORK_POLICY np
        on lh.user_name = np.name
    group by lh.user_name, np.VALUE, np.default, np.level, np.DESCRIPTION
)
select logins.USER_NAME,
       logins.FIRST_AUTHENTICATION_FACTOR,
       logins.SECOND_AUTHENTICATION_FACTOR,
       start_mfa.POLICY_VALUE,
       start_mfa.POLICY_DEFAULT,
       start_mfa.POLICY_LEVEL,
       start_mfa.POLICY_DESCRIPTION,
       case when POLICY_VALUE is not null then True else False END as SERVICE_USER,
       case when logins.SECOND_AUTHENTICATION_FACTOR is not null
          then True else False end as MFA_ENABLED,
       max(logins.event_timestamp) last_event
from admin.SNOWFLAKE_LOGIN_HISTORY logins
inner join start_mfa on logins.user_name = start_mfa.user_name
where logins.event_timestamp >= start_mfa.last_login_event_timestamp
group by logins.USER_NAME,
       logins.FIRST_AUTHENTICATION_FACTOR,
       logins.SECOND_AUTHENTICATION_FACTOR,
       start_mfa.POLICY_VALUE,
       start_mfa.POLICY_DEFAULT,
       start_mfa.POLICY_LEVEL,
       start_mfa.POLICY_DESCRIPTION
order by logins.USER_NAME;


use role USER_ACCESS_VIEWER;
select * from ADMIN.SNOWFLAKE_USER_AUTHENTICATION_VIEW;

--- Generate Dictionary Template
select HTML from (
                     select 0 row_idx, '<table><tr><th>COLUMN_NAME</th><th>DESCRIPTION</th><tr>' HTML
                     UNION
                     select row_number() over (order by COLUMN_NAME asc), '<tr><td>' || COLUMN_NAME || '</td><td></td></tr>'
                     from INFORMATION_SCHEMA.COLUMNS
                     where TABLE_NAME = 'SNOWFLAKE_USER_AUTHENTICATION_VIEW'
                     union
                     select 2000, '</table>'
                 )
order by row_idx