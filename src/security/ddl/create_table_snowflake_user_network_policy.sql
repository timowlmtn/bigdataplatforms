create or replace table ADMIN.SNOWFLAKE_USER_NETWORK_POLICY
(
    name           VARCHAR,
    key VARCHAR,
    value varchar,
    default varchar,
    level varchar,
    description varchar,
    type varchar,
    CREATED_DATE   TIMESTAMPLTZ default CURRENT_TIMESTAMP() not null,
    CREATED_BY     VARCHAR(100) default CURRENT_USER()      not null
)