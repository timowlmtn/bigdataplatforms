create or replace table warehouse.fact_radio_playlist
(
    playlist_key    INT primary key identity (1,1),
    load_id        INT           NOT NULL,
    playlist_id    INT UNIQUE    NOT NULL,
    play_type      string        NOT NULL,
    airdate        TIMESTAMP_LTZ not null,
    album          STRING        null,
    artist         STRING        null,
    song           STRING        null,
    show_id        INT NOT NULL,
    DW_CREATE_DATE TIMESTAMPTZ            DEFAULT CURRENT_TIMESTAMP(),
    DW_CREATE_USER VARCHAR       NOT NULL DEFAULT CURRENT_USER(),
    DW_UPDATE_DATE TIMESTAMPTZ            DEFAULT CURRENT_TIMESTAMP(),
    DW_UPDATE_USER VARCHAR       NOT NULL DEFAULT CURRENT_USER(),
    FOREIGN KEY (load_id) REFERENCES STAGE.raw_kexp_playlist (LOAD_ID),
    FOREIGN KEY (show_id) REFERENCES warehouse.DIM_KEXP_SHOW (SHOW_ID)
);

grant select on warehouse.fact_kexp_playlist to role KEXP_READER_ACCESS;

