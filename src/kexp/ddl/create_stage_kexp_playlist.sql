create or replace table stage.kexp_playlist
(
    load_id         INT primary key identity (1,1),
    filename        STRING not null,
    file_row_number INT    not null,
    value           variant
);
