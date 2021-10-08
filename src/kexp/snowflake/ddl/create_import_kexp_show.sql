create or replace table stage.import_kexp_show
(
    load_id         INT primary key identity (1,1),
    filename        string     not null,
    file_row_number int        not null,
    show_id         INT UNIQUE NOT NULL,
    program_id      INT        NOT NULL,
    program_name    VARCHAR    NOT NULL,
    PROGRAM_TAGS    VARCHAR    NULL,
    host_names      VARIANT    NOT NULL,
    tagline         VARCHAR,
    start_time     TIMESTAMP_LTZ NOT NULL,
    DW_CREATE_DATE  TIMESTAMPTZ         DEFAULT CURRENT_TIMESTAMP(),
    DW_CREATE_USER  VARCHAR    NOT NULL DEFAULT CURRENT_USER(),
    DW_UPDATE_DATE  TIMESTAMPTZ         DEFAULT CURRENT_TIMESTAMP(),
    DW_UPDATE_USER  VARCHAR    NOT NULL DEFAULT CURRENT_USER()
);


