CREATE or replace TASK ADMIN.APPEND_SNOWFLAKE_LOGIN_HISTORY
  WAREHOUSE = COMPUTE_WH
  SCHEDULE = 'USING CRON * * * * SUN-SAT America/New_York'
AS
insert into admin.SNOWFLAKE_LOGIN_HISTORY(EVENT_TIMESTAMP, EVENT_ID, EVENT_TYPE, USER_NAME, CLIENT_IP,
                                          REPORTED_CLIENT_TYPE, REPORTED_CLIENT_VERSION, FIRST_AUTHENTICATION_FACTOR,
                                          SECOND_AUTHENTICATION_FACTOR, IS_SUCCESS, ERROR_CODE, ERROR_MESSAGE,
                                          RELATED_EVENT_ID)
select EVENT_TIMESTAMP,
       EVENT_ID,
       EVENT_TYPE,
       USER_NAME,
       CLIENT_IP,
       REPORTED_CLIENT_TYPE,
       REPORTED_CLIENT_VERSION,
       FIRST_AUTHENTICATION_FACTOR,
       SECOND_AUTHENTICATION_FACTOR,
       IS_SUCCESS,
       ERROR_CODE,
       ERROR_MESSAGE,
       RELATED_EVENT_ID
from table (information_schema.login_history(
        time_range_start => (select coalesce(max(DW_CREATE_DATE), dateadd('days',-6,current_timestamp()))
                             from admin.SNOWFLAKE_LOGIN_HISTORY
            )));

