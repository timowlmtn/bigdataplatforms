!set variable_substitution=true;
/*
Quick method to create a table from json.

create table if not exists STAGE.KEXP_PROGRAM as
SELECT parse_json($1)
FROM @stage.STAGE_KEXP_PROGRAM
    (file_format => 'JSON_FILE_FORMAT',
     pattern => '.*20230221043945.*' ) t;

 */
use role &{DATABASE_ADMIN_ROLE};

create table if not exists STAGE.IMPORT_KEXP_PROGRAM
(
    IMPORT_KEXP_PROGRAM_KEY INT PRIMARY KEY AUTOINCREMENT START 1 INCREMENT 1,
    LOAD_ID        INT UNIQUE NOT NULL DEFAULT STAGE.LOAD_ID_SEQUENCE.nextval,
    FILENAME        STRING        NOT NULL,
    FILE_ROW_NUMBER INT           NOT NULL,
    ID             number,
    DESCRIPTION    varchar,
    IS_ACTIVE      boolean,
    NAME           varchar,
    TAGS           varchar,
    URI            varchar,
    DW_CREATE_DATE TIMESTAMPTZ         DEFAULT CURRENT_TIMESTAMP(),
    DW_CREATE_USER VARCHAR    NOT NULL DEFAULT CURRENT_USER(),
    DW_UPDATE_DATE TIMESTAMPTZ         DEFAULT CURRENT_TIMESTAMP(),
    DW_UPDATE_USER VARCHAR    NOT NULL DEFAULT CURRENT_USER()
);

