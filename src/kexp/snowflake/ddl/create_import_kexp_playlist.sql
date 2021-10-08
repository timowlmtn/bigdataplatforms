create or replace table stage.import_kexp_playlist
(
    load_id         INT primary key identity (1,1),
    filename        string        not null,
    file_row_number int           not null,
    playlist_id     INT UNIQUE    NOT NULL,
    play_type       string        NOT NULL,
    airdate         TIMESTAMP_LTZ not null,
    album           STRING        null,
    artist          STRING        null,
    song            STRING        null,
    show_id         INT           NOT NULL,
    DW_CREATE_DATE  TIMESTAMPTZ            DEFAULT CURRENT_TIMESTAMP(),
    DW_CREATE_USER  VARCHAR       NOT NULL DEFAULT CURRENT_USER(),
    DW_UPDATE_DATE  TIMESTAMPTZ            DEFAULT CURRENT_TIMESTAMP(),
    DW_UPDATE_USER  VARCHAR       NOT NULL DEFAULT CURRENT_USER()
);

grant select on stage.IMPORT_KEXP_PLAYLIST to role KEXP_READER_ACCESS;
