use role ACCOUNTADMIN;

CREATE OR REPLACE PROCEDURE ADMIN.SNAPSHOT_USER_GRANT()
RETURNS VARCHAR
    LANGUAGE JAVASCRIPT
    COMMENT = 'Insert USER policy information into  ADMIN.SNOWFLAKE_USER_GRANT'
    EXECUTE AS CALLER
        AS
$$
    var result = "SUCCESS";
    try {
        snowflake.execute( {sqlText: "TRUNCATE TABLE ADMIN.SNOWFLAKE_USER_GRANT;"} );

        var sql_command = "select \"name\" as NAME from ADMIN.SNOWFLAKE_USERS where \"name\" <> \'SNOWFLAKE\'";
        var stmt = snowflake.createStatement( {sqlText: sql_command} );
        var resultSet = stmt.execute();
        while (resultSet.next())  {
            userName = resultSet.getColumnValue('NAME')
            snowflake.execute( {sqlText: "show grants to user %s".replace('%s', userName)} );

            var insert_user_row =
                `insert into ADMIN.SNOWFLAKE_USER_GRANT(
                    CREATED_ON,
                    ROLE,
                    GRANTED_TO,
                    GRANTEE_NAME,
                    GRANTED_BY,
                    DW_CREATED_DATE,
                    DW_CREATED_BY
                 )
                select "created_on",
                    "role",
                    "granted_to",
                    "grantee_name",
                    "granted_by",
                    CURRENT_TIMESTAMP(),
                    CURRENT_USER() from
                  table(result_scan(last_query_id()));`;
            snowflake.execute( {sqlText: insert_user_row} );
        }

    } catch (err) {
        result = "FAILED: Code: " + err.code + "\n State: " + err.state;
        result += "\n Message: " + err.message;
        result += "\nStack Trace:\n" + err.stackTraceTxt;
    }
        return result;
$$;