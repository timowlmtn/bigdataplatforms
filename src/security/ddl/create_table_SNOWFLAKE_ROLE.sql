create or replace table ADMIN.SNOWFLAKE_ROLE
(
    name              VARCHAR primary key,
    created_on        VARCHAR,
    is_default        varchar,
    is_current        varchar,
    is_inherited      varchar,
    assigned_to_users varchar,
    granted_to_roles  varchar,
    granted_roles     varchar,
    owner             varchar,
    comment           varchar,
    DW_CREATED_DATE     TIMESTAMPLTZ default CURRENT_TIMESTAMP() not null,
    DW_CREATED_BY       VARCHAR(100) default CURRENT_USER()      not null
);
