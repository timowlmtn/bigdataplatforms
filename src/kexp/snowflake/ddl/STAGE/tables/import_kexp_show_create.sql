!set variable_substitution= true;
use role &{DATABASE_ADMIN_ROLE};

create table if not exists stage.import_kexp_show
(
    load_id         INT primary key identity (1,1),
    filename        string  not null,
    file_row_number int     not null,
    show_id         INT UNIQUE,
    program_id      INT,
    program_name    VARCHAR,
    PROGRAM_TAGS    VARCHAR NULL,
    host_names      VARIANT,
    tagline         VARCHAR,
    start_time      TIMESTAMP_LTZ,
    DW_CREATE_DATE  TIMESTAMPTZ      DEFAULT CURRENT_TIMESTAMP(),
    DW_CREATE_USER  VARCHAR NOT NULL DEFAULT CURRENT_USER(),
    DW_UPDATE_DATE  TIMESTAMPTZ      DEFAULT CURRENT_TIMESTAMP(),
    DW_UPDATE_USER  VARCHAR NOT NULL DEFAULT CURRENT_USER()
);
