select *
from OWLMTN.ADMIN.SNOWFLAKE_USERS;

show roles;

show users;

show grants on account;

show grants on database owlmtn;

use role ACCOUNTADMIN;

select *
from admin.SNOWFLAKE_USERS;

select *
from admin.SNOWFLAKE_USER_GRANT;

show grants to user TIMBURNSOWLMTN1;

show grants to role APPADMIN;

show grants;

show users;

show roles;



select *
from table(information_schema.login_history_by_user('TIMBURNSOWLMTN1', result_limit=>1000))
order by event_timestamp;
