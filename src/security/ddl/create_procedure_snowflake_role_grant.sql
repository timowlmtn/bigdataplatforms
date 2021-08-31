CREATE OR REPLACE PROCEDURE ADMIN.SNAPSHOT_ROLE_GRANT()
RETURNS VARCHAR
    LANGUAGE JAVASCRIPT
    COMMENT = 'Insert USER policy information into  ADMIN.SNOWFLAKE_ROLE_GRANT'
    EXECUTE AS CALLER
        AS
$$
    var result = "SUCCESS";
    try {
        snowflake.execute( {sqlText: "TRUNCATE TABLE ADMIN.SNOWFLAKE_ROLE_GRANT;"} );

        var sql_command = "select NAME from ADMIN.SNOWFLAKE_ROLE";
        var stmt = snowflake.createStatement( {sqlText: sql_command} );
        var resultSet = stmt.execute();
        while (resultSet.next())  {
            roleName = resultSet.getColumnValue('NAME')
            snowflake.execute( {sqlText: "show grants to role %s".replace('%s', roleName)} );

            var insert_user_row =
                `insert into ADMIN.SNOWFLAKE_ROLE_GRANT(
                    role,
                    created_on, 
                    privilege, 
                    granted_on, 
                    name, 
                    granted_to, 
                    grantee_name, 
                    grant_option, 
                    granted_by)
                select
                    \'%s\',
                    "created_on",
                    "privilege", 
                    "granted_on", 
                    "name", 
                    "granted_to", 
                    "grantee_name", 
                    "grant_option", 
                    "granted_by" from
                  table(result_scan(last_query_id()));`.replace('%s', roleName);
            snowflake.execute( {sqlText: insert_user_row} );
        }

    } catch (err) {
        result = "FAILED: Code: " + err.code + "\n State: " + err.state;
        result += "\n Message: " + err.message;
        result += "\nStack Trace:\n" + err.stackTraceTxt;
    }
        return result;
$$;