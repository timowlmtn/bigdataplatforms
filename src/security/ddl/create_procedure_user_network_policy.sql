CREATE OR REPLACE PROCEDURE ADMIN.SNAPSHOT_USER_NETWORK_POLICY()
RETURNS VARCHAR
    LANGUAGE JAVASCRIPT
    COMMENT = 'Insert USER policy information into  ADMIN.SNOWFLAKE_USER_NETWORK_POLICY'
    EXECUTE AS CALLER
        AS
$$
    var result = "SUCCESS";
    try {
        snowflake.execute( {sqlText: "TRUNCATE TABLE ADMIN.SNOWFLAKE_USER_NETWORK_POLICY;"} );

        var sql_command = "select \"name\" as NAME from ADMIN.SNOWFLAKE_USER where \"name\" <> \'SNOWFLAKE\'";
        var stmt = snowflake.createStatement( {sqlText: sql_command} );
        var resultSet = stmt.execute();
        while (resultSet.next())  {
            userName = resultSet.getColumnValue('NAME')
            snowflake.execute( {sqlText: "show parameters like 'network_policy' in user %s"
                                            .replace('%s', userName)} );

            var insert_user_row =
                `insert into ADMIN.SNOWFLAKE_USER_NETWORK_POLICY(NAME,KEY,VALUE,DEFAULT,LEVEL,DESCRIPTION,TYPE)
                 select \'%s\',
                        "key",
                        "value",
                        "default",
                        "level",
                        "description",
                        "type"
                 from table(result_scan(last_query_id()));`.replace('%s', userName);
            snowflake.execute( {sqlText: insert_user_row} );


        }

    } catch (err) {
        result = "FAILED: Code: " + err.code + "\n State: " + err.state;
        result += "\n Message: " + err.message;
        result += "\nStack Trace:\n" + err.stackTraceTxt;
    }
        return result;
$$;