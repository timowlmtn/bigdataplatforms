create or replace table warehouse.fact_kexp_playlist
(
    load_id INT           NOT NULL,
    play_type string      NOT NULL,
    airdate TIMESTAMP_LTZ not null,
    album   STRING        null,
    artist  STRING        null,
    song    STRING        null,
    FOREIGN KEY (load_id) REFERENCES STAGE.kexp_playlist (LOAD_ID)
);


