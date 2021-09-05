CREATE OR REPLACE PROCEDURE ADMIN.APPEND_SNOWFLAKE_LOGIN_HISTORY()
RETURNS VARCHAR
    LANGUAGE JAVASCRIPT
    COMMENT = 'Append Login History to an Analytics Table'
    EXECUTE AS CALLER
        AS
$$
        var result = "SUCCESS";
        var sql_command = `
select to_varchar(
    case when
        coalesce( max(DW_CREATE_DATE), dateadd('days',-6,current_timestamp())) >
        dateadd('days',-6,current_timestamp()) then
        coalesce(max(DW_CREATE_DATE), dateadd('days',-6,current_timestamp()))
        else
        dateadd('days',-6,current_timestamp())  end,
        'YYYY-MM-DD HH:MM:SS.FF9 TZH:TZM') last_timestamp
from admin.SNOWFLAKE_LOGIN_HISTORY;
        `

        try {
            var stmt = snowflake.createStatement( {sqlText: sql_command} );
            var resultSet = stmt.execute();
            while (resultSet.next())  {
                last_timestamp = resultSet.getColumnValue('LAST_TIMESTAMP')

                var append_login_sql = `
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
from table(information_schema.login_history(
    time_range_start=>to_timestamp_ltz('%s')))
order by event_timestamp;`.replace('%s', last_timestamp )
                snowflake.execute( {sqlText: append_login_sql} );

            }

        } catch (err) {
            result = "FAILED: Code: " + err.code + "\n State: " + err.state;
            result += "\n Message: " + err.message;
            result += "\nStack Trace:\n" + err.stackTraceTxt;
        }
        return result;
$$;

