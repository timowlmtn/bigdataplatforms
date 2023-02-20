CREATE TABLE IF NOT EXISTS WAREHOUSE.FACT_RADIO_PLAYLIST
(
    FACT_RADIO_PLAYLIST_KEY INT PRIMARY KEY IDENTITY (1,1)
        comment 'A unique identifier for the fact table row.',

    DIM_CALENDAR_KEY  INT           NOT NULL FOREIGN KEY REFERENCES warehouse.DIM_CALENDAR(DIM_CALENDAR_KEY)
        comment 'A foreign key that references the dimension table containing date ',

    DIM_RADIO_PROGRAM_KEY      INT           NOT NULL FOREIGN KEY REFERENCES WAREHOUSE.DIM_RADIO_PROGRAM (DIM_RADIO_PROGRAM_KEY)
        comment 'A foreign key to the program dimension',
    DIM_RADIO_STATION_KEY   INT           NOT NULL FOREIGN KEY REFERENCES WAREHOUSE.DIM_RADIO_STATION (DIM_RADIO_STATION_KEY)
        comment 'A foreign key to the station dimension',

    LOAD_ID           INT           NOT NULL
        comment 'A key referencing the LOAD_ID on the table from the STAGE schema where the fact originated.',
    PLAYLIST_ID       INT UNIQUE    NOT NULL,
    PLAY_TYPE         STRING        NULL,
    AIRDATE           TIMESTAMP_LTZ NOT NULL,
    ALBUM             STRING        NULL,
    ARTIST            STRING        NULL,
    SONG              STRING        NULL,

    COMMENT           VARCHAR,
    IMAGE_URI         VARCHAR,
    LABELS            VARIANT,
    RELEASE_DATE      VARCHAR,
    DW_CREATE_DATE    TIMESTAMPTZ            DEFAULT CURRENT_TIMESTAMP(),
    DW_CREATE_USER    VARCHAR       NOT NULL DEFAULT CURRENT_USER(),
    DW_UPDATE_DATE    TIMESTAMPTZ            DEFAULT CURRENT_TIMESTAMP(),
    DW_UPDATE_USER    VARCHAR       NOT NULL DEFAULT CURRENT_USER()

);

