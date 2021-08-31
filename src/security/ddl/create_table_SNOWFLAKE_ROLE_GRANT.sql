create or replace table OWLMTN.ADMIN.SNOWFLAKE_ROLE_GRANT
(
    role         VARCHAR,
    created_on      VARCHAR,
    privilege     varchar,
    granted_on    varchar,
    name          varchar,
    granted_to    varchar,
    grantee_name  varchar,
    grant_option  varchar,
    granted_by    varchar,
    DW_CREATED_DATE TIMESTAMPLTZ default CURRENT_TIMESTAMP() not null,
    DW_CREATED_BY   VARCHAR(100) default CURRENT_USER()      not null,
    FOREIGN KEY (role) REFERENCES ADMIN.SNOWFLAKE_ROLE (name)

)



