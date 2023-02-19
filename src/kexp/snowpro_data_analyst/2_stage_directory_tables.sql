use schema STAGE;
show stages;

-- Retrieve the history of data files registered in the metadata of specified objects and the credits billed
-- for these operations.
--- AUTO_REFRESH_REGISTRATION_HISTORY
select *
  from table(information_schema.auto_refresh_registration_history(
    date_range_start=>to_timestamp_tz(dateadd(day, -7, current_timestamp())),
    date_range_end=>to_timestamp_tz(current_timestamp()),
    object_type=>'DIRECTORY_TABLE'));


show storage integrations ;

--- Specifying "directory" on a stage allows you to utilize STAGE_DIRECTORY_FILE_REGISTRATION_HISTORY
--- to do data discovery on a set of data.
create stage if not exists KEXP_SHOWS
  url='s3://owlmtn-stage-data/stage/kexp/shows/'
  storage_integration = OWLMTN_S3_DATA
  directory = (
    enable = true
    auto_refresh = true
  );

select *
  from table(information_schema.stage_directory_file_registration_history(
  stage_name=>'KEXP_SHOWS'));

select sum(FILE_SIZE)/1e6 dataset_size_mb, count(distinct FILE_NAME) number_files
  from table(information_schema.stage_directory_file_registration_history(
  stage_name=>'KEXP_SHOWS'));

create stage if not exists KEXP_PLAYLISTS
  url='s3://owlmtn-stage-data/stage/kexp/playlists/'
  storage_integration = OWLMTN_S3_DATA
  directory = (
    enable = true
    auto_refresh = true
  );

select sum(FILE_SIZE)/1e6 dataset_size_mb, count(distinct FILE_NAME) number_files
  from table(information_schema.stage_directory_file_registration_history(
  stage_name=>'KEXP_PLAYLISTS'));
