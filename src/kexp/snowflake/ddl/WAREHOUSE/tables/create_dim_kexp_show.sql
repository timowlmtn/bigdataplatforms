create or replace table warehouse.dim_kexp_show
(
    show_key       INT primary key identity (1,1),
    load_id        INT           NULL,
    station_id     VARCHAR       NULL,
    show_id        INT UNIQUE    NOT NULL,
    program_id     INT           NULL,
    program_name   VARCHAR       NULL,
    PROGRAM_TAGS   VARCHAR       NULL,
    host_names     VARIANT       NULL,
    tagline        VARCHAR,
    start_time     TIMESTAMP_LTZ NOT NULL,
    DW_ACTIVE      BOOLEAN                default TRUE not null,
    DW_MATCH_HASH  VARCHAR                default md5(show_id),
    DW_FROM_DATE   TIMESTAMPLTZ,
    DW_TO_DATE     TIMESTAMPLTZ           default CAST('2099-12-31 00:00:00' AS TIMESTAMP_LTZ(9)) not null,
    DW_CREATE_DATE TIMESTAMPTZ            DEFAULT CURRENT_TIMESTAMP(),
    DW_CREATE_USER VARCHAR       NOT NULL DEFAULT CURRENT_USER(),
    DW_UPDATE_DATE TIMESTAMPTZ            DEFAULT CURRENT_TIMESTAMP(),
    DW_UPDATE_USER VARCHAR       NOT NULL DEFAULT CURRENT_USER()
);
