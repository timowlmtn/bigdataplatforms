with start_mfa as (
    select user_name,
           max(event_timestamp) event_timestamp
    from admin.SNOWFLAKE_LOGIN_HISTORY lh
    inner join admin.SNOWFLAKE_USER_NETWORK_POLICY np
        on lh.user_name = np.name
    where len(np.value) = 0
    group by lh.user_name
)
select logins.USER_NAME, logins.event_timestamp, logins.SECOND_AUTHENTICATION_FACTOR
from admin.SNOWFLAKE_LOGIN_HISTORY logins
inner join start_mfa on logins.user_name = start_mfa.user_name
where logins.event_timestamp >= start_mfa.event_timestamp
order by logins.event_timestamp;