CREATE OR REPLACE PROCEDURE STAGE.SNAPSHOT_USERS()
RETURNS VARCHAR
    LANGUAGE JAVASCRIPT
    COMMENT = 'Captures the snapshot of users and inserts the records into STAGE.SNOWFLAKE_USERS'
    EXECUTE AS CALLER
        AS
$$
    var result = "SUCCESS";
    try {
        snowflake.execute( {sqlText: "TRUNCATE TABLE STAGE.SNOWFLAKE_USERS;"} );
        snowflake.execute( {sqlText: "show users;"} );
        var dbusers_tbl_sql = 'insert into STAGE.SNOWFLAKE_USERS select *,  CURRENT_TIMESTAMP(), CURRENT_USER() from table(result_scan(last_query_id()));';
        snowflake.execute( {sqlText: dbusers_tbl_sql} );
    } catch (err) {
        result = "FAILED: Code: " + err.code + "\n State: " + err.state;
        result += "\n Message: " + err.message;
        result += "\nStack Trace:\n" + err.stackTraceTxt;
    }
        return result;
$$;
