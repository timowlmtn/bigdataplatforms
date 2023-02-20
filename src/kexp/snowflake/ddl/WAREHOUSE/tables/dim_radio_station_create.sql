-- CREATED BY CHATGPT
CREATE TABLE IF NOT EXISTS WAREHOUSE.DIM_RADIO_STATION
(
    DIM_RADIO_STATION_KEY INT PRIMARY KEY AUTOINCREMENT START 1 INCREMENT 1,
    STATION_ID      INT UNIQUE     NOT NULL DEFAULT WAREHOUSE.ID_SEQUENCE.NEXTVAL,
    STATION_NAME    VARCHAR UNIQUE NOT NULL,
    FREQUENCY       FLOAT,
    LOCATION        VARCHAR,
    OWNER           VARCHAR,
    FORMAT          VARCHAR,
    API             VARCHAR,
    URI             VARCHAR,
    dw_current            BOOLEAN             DEFAULT TRUE NOT NULL comment 'A flag that indicates whether the row is the current version of the dimension entity.',
    dw_start_date         TIMESTAMPLTZ comment 'The date on which the dimension row becomes valid.',
    dw_end_date           TIMESTAMPLTZ        DEFAULT CAST('2099-12-31 00:00:00' AS TIMESTAMP_LTZ(9)) NOT NULL comment 'The date on which the dimension row becomes invalid.',
    dw_create_date        TIMESTAMPTZ         DEFAULT CURRENT_TIMESTAMP() comment 'The date on which the dimension row was loaded into the data warehouse.',
    dw_create_user        VARCHAR    NOT NULL DEFAULT CURRENT_USER() comment 'The user loading the data',
    dw_update_date        TIMESTAMPTZ         DEFAULT CURRENT_TIMESTAMP() comment 'The date on which the dimension row was last updated.',
    dw_update_user        VARCHAR    NOT NULL DEFAULT CURRENT_USER() comment 'The user updating the data'
);
