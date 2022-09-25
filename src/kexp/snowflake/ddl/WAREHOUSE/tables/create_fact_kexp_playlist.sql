create or replace table warehouse.FACT_KEXP_PLAYLIST
(
    playlist_key   INT primary key identity (1,1),
    load_id        INT           NOT NULL,
    playlist_id    INT UNIQUE    NOT NULL,
    play_type      string        NULL,
    airdate        TIMESTAMP_LTZ not null,
    album          STRING        null,
    artist         STRING        null,
    song           STRING        null,
    show_id        INT           NOT NULL,
    COMMENT        varchar,
    IMAGE_URI      varchar,
    LABELS         variant,
    RELEASE_DATE   varchar,
    DW_ACTIVE      BOOLEAN                default TRUE not null,
    DW_MATCH_HASH  VARCHAR                default md5(playlist_id),
    DW_FROM_DATE   TIMESTAMPLTZ,
    DW_TO_DATE     TIMESTAMPLTZ           default CAST('2099-12-31 00:00:00' AS TIMESTAMP_LTZ(9)) not null,
    DW_CREATE_DATE TIMESTAMPTZ            DEFAULT CURRENT_TIMESTAMP(),
    DW_CREATE_USER VARCHAR       NOT NULL DEFAULT CURRENT_USER(),
    DW_UPDATE_DATE TIMESTAMPTZ            DEFAULT CURRENT_TIMESTAMP(),
    DW_UPDATE_USER VARCHAR       NOT NULL DEFAULT CURRENT_USER(),
    FOREIGN KEY (show_id) REFERENCES warehouse.DIM_KEXP_SHOW (SHOW_ID)
);

