CREATE OR REPLACE PROCEDURE ADMIN.SNAPSHOT_USERS()
RETURNS VARCHAR
    LANGUAGE JAVASCRIPT
    COMMENT = 'Captures the snapshot of users and inserts the records into ADMIN.SNOWFLAKE_USER'
    EXECUTE AS CALLER
        AS
$$
    var result = "SUCCESS";
    try {
        snowflake.execute( {sqlText: "TRUNCATE TABLE ADMIN.SNOWFLAKE_USER;"} );
        snowflake.execute( {sqlText: "show users;"} );
        var dbusers_tbl_sql = `
        insert into ADMIN.SNOWFLAKE_USER(
            NAME,
            CREATED_ON,
            LOGIN_NAME,
            DISPLAY_NAME,
            FIRST_NAME,
            LAST_NAME,
            EMAIL,
            MINS_TO_UNLOCK,
            DAYS_TO_EXPIRY,
            COMMENT,
            DISABLED,
            MUST_CHANGE_PASSWORD,
            SNOWFLAKE_LOCK,
            DEFAULT_WAREHOUSE,
            DEFAULT_NAMESPACE,
            DEFAULT_ROLE,
            EXT_AUTHN_DUO,
            EXT_AUTHN_UID,
            MINS_TO_BYPASS_MFA,
            OWNER,
            LAST_SUCCESS_LOGIN,
            EXPIRES_AT_TIME,
            LOCKED_UNTIL_TIME,
            HAS_PASSWORD,
            HAS_RSA_PUBLIC_KEY
        )
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
            "has_rsa_public_key"
            from table(result_scan(last_query_id()));`;
        snowflake.execute( {sqlText: dbusers_tbl_sql} );
    } catch (err) {
        result = "FAILED: Code: " + err.code + "\n State: " + err.state;
        result += "\n Message: " + err.message;
        result += "\nStack Trace:\n" + err.stackTraceTxt;
    }
        return result;
$$;
