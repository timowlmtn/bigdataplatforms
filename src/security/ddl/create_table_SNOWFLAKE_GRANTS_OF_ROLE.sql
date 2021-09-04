create or replace table ADMIN.SNOWFLAKE_GRANTS_OF_ROLE(
    created_on TIMESTAMP_LTZ,
    role VARCHAR,
    granted_to VARCHAR,
    grantee_name VARCHAR,
    granted_by VARCHAR,
	DW_CREATE_DATE TIMESTAMPLTZ not null default current_timestamp(),
	DW_CREATED_BY VARCHAR not null default current_user(),
    FOREIGN KEY (role) REFERENCES ADMIN.SNOWFLAKE_ROLE (name)
)