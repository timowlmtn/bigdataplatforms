!set variable_substitution=true;
create or replace table &{STAGE_SCHEMA}.simple_table
(
    simple_key         INT primary key identity,
    ID                 INT     not null,
    NAME               STRING,
    VALUE              STRING,
    DW_CREATE_DATE     TIMESTAMPTZ      DEFAULT CURRENT_TIMESTAMP(),
    DW_CREATE_USER     VARCHAR NOT NULL DEFAULT CURRENT_USER(),
    DW_UPDATE_DATE     TIMESTAMPTZ      DEFAULT CURRENT_TIMESTAMP(),
    DW_UPDATE_USER     VARCHAR NOT NULL DEFAULT CURRENT_USER(),
    DW_FILENAME        VARCHAR NOT NULL,
    DW_FILE_ROW_NUMBER VARCHAR NOT NULL,
    DW_ACTIVE          BOOLEAN NOT NULL DEFAULT TRUE
);

