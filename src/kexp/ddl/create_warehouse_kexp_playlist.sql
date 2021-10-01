create or replace table warehouse.fact_kexp_playlist
(
    playlist_id    INT primary key identity (1,1),
    load_id        INT           NOT NULL,
    play_type      string        NOT NULL,
    airdate        TIMESTAMP_LTZ not null,
    album          STRING        null,
    artist         STRING        null,
    song           STRING        null,
    DW_CREATE_DATE TIMESTAMPTZ            DEFAULT CURRENT_TIMESTAMP(),
    DW_CREATE_USER VARCHAR       NOT NULL DEFAULT CURRENT_USER(),
    DW_UPDATE_DATE TIMESTAMPTZ            DEFAULT CURRENT_TIMESTAMP(),
    DW_UPDATE_USER VARCHAR       NOT NULL DEFAULT CURRENT_USER(),
    FOREIGN KEY (load_id) REFERENCES STAGE.raw_kexp_playlist (LOAD_ID)
);


