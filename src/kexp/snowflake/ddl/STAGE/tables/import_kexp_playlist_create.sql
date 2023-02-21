create table if not exists stage.import_kexp_playlist
(
    IMPORT_KEXP_PLAYLIST_KEY INT PRIMARY KEY AUTOINCREMENT START 1 INCREMENT 1,
    LOAD_ID        INT UNIQUE NOT NULL DEFAULT STAGE.LOAD_ID_SEQUENCE.nextval, -- A load id
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
