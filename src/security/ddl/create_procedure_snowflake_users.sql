CREATE OR REPLACE PROCEDURE ADMIN.SNAPSHOT_USERS()
RETURNS VARCHAR
    LANGUAGE JAVASCRIPT
    COMMENT = 'Captures the snapshot of users and inserts the records into ADMIN.SNOWFLAKE_USERS'
    EXECUTE AS CALLER
        AS
$$
    var result = "SUCCESS";
    try {
        snowflake.execute( {sqlText: "TRUNCATE TABLE ADMIN.SNOWFLAKE_USERS;"} );
        snowflake.execute( {sqlText: "show users;"} );
        var dbusers_tbl_sql = `
        insert into ADMIN.SNOWFLAKE_USERS
        select
            "name",
            "created_on",
            "login_name",
            "display_name",
            "first_name",
            "last_name",
            "email",
            "mins_to_unlock",
            "days_to_expiry",
            "comment",
            "disabled",
            "must_change_password",
            "snowflake_lock",
            "default_warehouse",
            "default_namespace",
            "default_role",
            "ext_authn_duo",
            "ext_authn_uid",
            "mins_to_bypass_mfa",
            "owner",
            "last_success_login",
            "expires_at_time",
            "locked_until_time",
            "has_password",
            "has_rsa_public_key",
            CURRENT_TIMESTAMP(),
            CURRENT_USER()
            from table(result_scan(last_query_id()));`;
        snowflake.execute( {sqlText: dbusers_tbl_sql} );
    } catch (err) {
        result = "FAILED: Code: " + err.code + "\n State: " + err.state;
        result += "\n Message: " + err.message;
        result += "\nStack Trace:\n" + err.stackTraceTxt;
    }
        return result;
$$;
