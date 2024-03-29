CREATE TABLE IF NOT EXISTS WAREHOUSE.FACT_RADIO_SHOW
(
    FACT_RADIO_SHOW_KEY INT PRIMARY KEY AUTOINCREMENT START 1 INCREMENT 1,
    DIM_CALENDAR_KEY    INT FOREIGN KEY REFERENCES WAREHOUSE.DIM_CALENDAR (DIM_CALENDAR_KEY),
    DIM_RADIO_STATION_KEY     INT FOREIGN KEY REFERENCES WAREHOUSE.DIM_RADIO_STATION (DIM_RADIO_STATION_KEY),
    DIM_RADIO_PROGRAM_KEY     INT FOREIGN KEY REFERENCES WAREHOUSE.DIM_RADIO_PROGRAM (DIM_RADIO_PROGRAM_KEY),

    LOAD_ID             INT           NOT NULL,
    SHOW_ID             INT UNIQUE    NOT NULL,
    PROGRAM_ID          INT           NULL,
    PROGRAM_NAME        VARCHAR       NULL,
    PROGRAM_TAGS        VARCHAR       NULL,
    HOST_NAMES          VARIANT       NULL,
    TAGLINE             VARCHAR,
    START_TIME          TIMESTAMP_LTZ NOT NULL,
    DW_ACTIVE           BOOLEAN                DEFAULT TRUE NOT NULL,
    DW_MATCH_HASH       VARCHAR                DEFAULT MD5(SHOW_ID),
    DW_FROM_DATE        TIMESTAMPLTZ,
    DW_TO_DATE          TIMESTAMPLTZ           DEFAULT CAST('2099-12-31 00:00:00' AS TIMESTAMP_LTZ(9)) NOT NULL,
    DW_CREATE_DATE      TIMESTAMPTZ            DEFAULT CURRENT_TIMESTAMP(),
    DW_CREATE_USER      VARCHAR       NOT NULL DEFAULT CURRENT_USER(),
    DW_UPDATE_DATE      TIMESTAMPTZ            DEFAULT CURRENT_TIMESTAMP(),
    DW_UPDATE_USER      VARCHAR       NOT NULL DEFAULT CURRENT_USER()
);
