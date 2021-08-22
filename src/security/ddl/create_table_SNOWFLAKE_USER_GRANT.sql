use role ACCOUNTADMIN;

create or replace table OWLMTN.ADMIN.SNOWFLAKE_USER_GRANT
(
    created_on           VARCHAR,
    role VARCHAR,
    granted_to varchar,
    grantee_name varchar,
    granted_by varchar,
    DW_CREATED_DATE   TIMESTAMPLTZ default CURRENT_TIMESTAMP() not null,
    DW_CREATED_BY     VARCHAR(100) default CURRENT_USER()      not null
)

