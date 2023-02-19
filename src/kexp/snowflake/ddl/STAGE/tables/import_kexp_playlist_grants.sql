
grant select on stage.IMPORT_KEXP_PLAYLIST to role KEXP_READER_ACCESS;

alter table stage.import_kexp_playlist add column comment varchar;

alter table stage.import_kexp_playlist add column image_uri varchar;
alter table stage.import_kexp_playlist add column labels variant;
alter table stage.import_kexp_playlist add column release_date varchar;
