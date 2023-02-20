create table if not exists WAREHOUSE.DIM_LOAD
(
    load_key       INT PRIMARY KEY AUTOINCREMENT START 1 INCREMENT 1
        comment 'A unique identifier for each load, used as a foreign key in the fact table.',
    load_id         INT UNIQUE comment 'A natural key referencing the LOAD_ID from the STAGE table',
    load_date_time TIMESTAMPTZ not null
        comment 'The date timestamp on which the data was loaded into the data warehouse.',
    source_system  VARCHAR(255)  not null
        comment 'The system or application from which the data was sourced.',
    source_file    TEXT          not null
        comment 'The name of the file or table from which the data was loaded.',
    load_frequency VARCHAR(255) comment 'The frequency with which the data is loaded (e.g. daily, weekly, monthly).',
    load_status    boolean
        comment 'A flag that indicates whether the load was successful or not.',
    error_message  TEXT
        comment 'A text field that contains any error messages generated during the load process.',
    dw_create_date TIMESTAMPTZ            DEFAULT CURRENT_TIMESTAMP()
        comment 'The date on which the dimension row was loaded into the data warehouse.',
    dw_create_user VARCHAR       NOT NULL DEFAULT CURRENT_USER()
        comment 'The user loading the data',
    dw_update_date TIMESTAMPTZ            DEFAULT CURRENT_TIMESTAMP()
        comment 'The date on which the dimension row was last updated.',
    dw_update_user VARCHAR       NOT NULL DEFAULT CURRENT_USER()
        comment 'The user updating the data'

);

select *
from STAGE.IMPORT_KEXP_SHOW;