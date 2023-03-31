CREATE TABLE IF NOT EXISTS warehouse.dim_radio_program
(
    dim_radio_program_key INT PRIMARY KEY AUTOINCREMENT START 1 INCREMENT 1 comment ' A surrogate key for the dimension row.',
    dim_radio_station_key INT        NOT NULL FOREIGN KEY REFERENCES WAREHOUSE.DIM_RADIO_STATION (DIM_RADIO_STATION_KEY)
        comment 'A foreign key to the station dimension',
    load_id               INT NOT NULL comment 'Global unique load id.',
    program_id            INT UNIQUE NOT NULL comment 'A business key (natural key) that uniquely identifies the dimension entity.',
    name                  VARCHAR(255) comment 'A unique identifier for each program',
    description           TEXT comment 'A brief description of the program''s content',
    host                  VARCHAR(255) comment 'The name of the person or people who host the program',
    producer              VARCHAR(255) comment 'The name of the person or people who produce the program',
    duration_minutes      INT comment 'The length of the program in minutes',
    start_time            DATETIME comment 'The start time of the program',
    end_time              DATETIME comment 'The end time of the program',
    target_audience       VARCHAR(255) comment 'The intended audience for the program',
    tags                  VARCHAR comment 'Arbitrary tags assigned to the show',
    genre                 VARCHAR(255) comment 'The genre or type of program (e.g. news, talk, music, etc.)',
    language              VARCHAR(255) comment 'The language in which the program is broadcast',
    website_url           VARCHAR(255) comment 'The website URL for the program (if applicable)',
    dw_current            BOOLEAN             DEFAULT TRUE NOT NULL comment 'A flag that indicates whether the row is the current version of the dimension entity.',
    dw_start_date         TIMESTAMPLTZ comment 'The date on which the dimension row becomes valid.',
    dw_end_date           TIMESTAMPLTZ        DEFAULT CAST('2099-12-31 00:00:00' AS TIMESTAMP_LTZ(9)) NOT NULL comment 'The date on which the dimension row becomes invalid.',
    dw_create_date        TIMESTAMPTZ         DEFAULT CURRENT_TIMESTAMP() comment 'The date on which the dimension row was loaded into the data warehouse.',
    dw_create_user        VARCHAR    NOT NULL DEFAULT CURRENT_USER() comment 'The user loading the data',
    dw_update_date        TIMESTAMPTZ         DEFAULT CURRENT_TIMESTAMP() comment 'The date on which the dimension row was last updated.',
    dw_update_user        VARCHAR    NOT NULL DEFAULT CURRENT_USER() comment 'The user updating the data'
);

