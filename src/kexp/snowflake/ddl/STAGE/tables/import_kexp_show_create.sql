create table if not exists stage.import_kexp_show
(
    IMPORT_KEXP_SHOW_KEY INT PRIMARY KEY AUTOINCREMENT START 1 INCREMENT 1,
    LOAD_ID              INT UNIQUE    NOT NULL DEFAULT STAGE.LOAD_ID_SEQUENCE.nextval, -- A shared load id
    filename             string        not null,
    file_row_number      int           not null,
    show_id              INT UNIQUE    NOT NULL,
    program_id           INT           NOT NULL,
    program_name         VARCHAR       NOT NULL,
    PROGRAM_TAGS         VARCHAR       NULL,
    host_names           VARIANT       NOT NULL,
    tagline              VARCHAR,
    start_time           TIMESTAMP_LTZ NOT NULL,
    DW_CREATE_DATE       TIMESTAMPTZ            DEFAULT CURRENT_TIMESTAMP(),
    DW_CREATE_USER       VARCHAR       NOT NULL DEFAULT CURRENT_USER(),
    DW_UPDATE_DATE       TIMESTAMPTZ            DEFAULT CURRENT_TIMESTAMP(),
    DW_UPDATE_USER       VARCHAR       NOT NULL DEFAULT CURRENT_USER()
);
