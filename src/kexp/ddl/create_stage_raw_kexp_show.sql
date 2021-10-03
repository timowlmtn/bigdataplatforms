create or replace table stage.raw_kexp_show
(
    load_id         INT primary key identity (1,1),
    filename        STRING  not null,
    file_row_number INT     not null,
    value           variant,
    DW_CREATE_DATE  TIMESTAMPTZ      DEFAULT CURRENT_TIMESTAMP(),
    DW_CREATE_USER  VARCHAR NOT NULL DEFAULT CURRENT_USER()
);
