create or replace view ADMIN.SNOWFLAKE_USER_STATUS_VIEW AS
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
       logins.event_timestamp,
       logins.FIRST_AUTHENTICATION_FACTOR,
       logins.SECOND_AUTHENTICATION_FACTOR,
       start_mfa.POLICY_VALUE,
       start_mfa.POLICY_DEFAULT,
       start_mfa.POLICY_LEVEL,
       start_mfa.POLICY_DESCRIPTION
from admin.SNOWFLAKE_LOGIN_HISTORY logins
inner join start_mfa on logins.user_name = start_mfa.user_name
where logins.event_timestamp >= start_mfa.last_login_event_timestamp
order by logins.event_timestamp;
