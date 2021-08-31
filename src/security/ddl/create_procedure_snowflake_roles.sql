CREATE OR REPLACE PROCEDURE ADMIN.SNAPSHOT_ROLES()
RETURNS VARCHAR
    LANGUAGE JAVASCRIPT
    COMMENT = 'Captures the snapshot of roles and inserts the records into ADMIN.SNOWFLAKE_ROLE'
    EXECUTE AS CALLER
        AS
$$
    var result = "SUCCESS";
    try {
        snowflake.execute( {sqlText: "TRUNCATE TABLE ADMIN.SNOWFLAKE_ROLE;"} );
        snowflake.execute( {sqlText: "show roles;"} );
        var dbusers_tbl_sql = `
        insert into ADMIN.SNOWFLAKE_ROLE(name,
            created_on,
            is_default,
            is_current,
            is_inherited,
            assigned_to_users,
            granted_to_roles,
            granted_roles,
            owner,
            comment
        )
        select
            "name",
            "created_on",
            "is_default",
            "is_current",
            "is_inherited",
            "assigned_to_users",
            "granted_to_roles",
            "granted_roles",
            "owner",
            "comment"
        from table(result_scan(last_query_id()));`;
        snowflake.execute( {sqlText: dbusers_tbl_sql} );
    } catch (err) {
        result = "FAILED: Code: " + err.code + "\n State: " + err.state;
        result += "\n Message: " + err.message;
        result += "\nStack Trace:\n" + err.stackTraceTxt;
    }
        return result;
$$;
