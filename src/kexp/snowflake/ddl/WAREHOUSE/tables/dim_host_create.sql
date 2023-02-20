CREATE TABLE IF NOT EXISTS warehouse.dim_radio_host
(
    DIM_HOST_KEY   INT PRIMARY KEY AUTOINCREMENT START 1 INCREMENT 1,
    HOST_ID        INT     NOT NULL,
    NAME           VARCHAR NULL,
    URI            VARCHAR NULL,
    IMAGE_URI      VARCHAR NULL,

    THUMBNAIL_URI  VARCHAR NULL,
    IS_ACTIVE      BOOLEAN NULL,
    dw_current            BOOLEAN             DEFAULT TRUE NOT NULL comment 'A flag that indicates whether the row is the current version of the dimension entity.',
    dw_start_date         TIMESTAMPLTZ comment 'The date on which the dimension row becomes valid.',
    dw_end_date           TIMESTAMPLTZ        DEFAULT CAST('2099-12-31 00:00:00' AS TIMESTAMP_LTZ(9)) NOT NULL comment 'The date on which the dimension row becomes invalid.',
    dw_create_date        TIMESTAMPTZ         DEFAULT CURRENT_TIMESTAMP() comment 'The date on which the dimension row was loaded into the data warehouse.',
    dw_create_user        VARCHAR    NOT NULL DEFAULT CURRENT_USER() comment 'The user loading the data',
    dw_update_date        TIMESTAMPTZ         DEFAULT CURRENT_TIMESTAMP() comment 'The date on which the dimension row was last updated.',
    dw_update_user        VARCHAR    NOT NULL DEFAULT CURRENT_USER() comment 'The user updating the data'
);
