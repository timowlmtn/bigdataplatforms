CREATE OR REPLACE PROCEDURE ADMIN.SNAPSHOT_GRANTS_OF_ROLE()
RETURNS VARCHAR
    LANGUAGE JAVASCRIPT
    COMMENT = 'Insert all grants of role into an ADMIN table for analysis.'
    EXECUTE AS CALLER
        AS
$$
    var result = "SUCCESS";
    try {
        snowflake.execute( {sqlText: "TRUNCATE TABLE ADMIN.SNOWFLAKE_GRANTS_OF_ROLE;"} );

        var sql_command = "select NAME from ADMIN.SNOWFLAKE_ROLE";
        var stmt = snowflake.createStatement( {sqlText: sql_command} );
        var resultSet = stmt.execute();
        while (resultSet.next())  {
            roleName = resultSet.getColumnValue('NAME')
            snowflake.execute( {sqlText: "show grants of role %s".replace('%s', roleName)} );

            var insert_user_row =
                `insert into ADMIN.SNOWFLAKE_GRANTS_OF_ROLE(
                    created_on,
                    role,
                    granted_to,
                    grantee_name,
                    granted_by
                )
                select
                    "created_on",
                    "role",
                    "granted_to",
                    "grantee_name",
                    "granted_by"
                  from
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