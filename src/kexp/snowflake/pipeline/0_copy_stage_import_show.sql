copy into stage.IMPORT_KEXP_SHOW (FILENAME,
                                  FILE_ROW_NUMBER,
                                  SHOW_ID,
                                  PROGRAM_ID,
                                  PROGRAM_NAME,
                                  PROGRAM_TAGS,
                                  HOST_NAMES,
                                  TAGLINE,
                                  START_TIME)
    from (
        select metadata$filename,
               metadata$file_row_number,
               $1:id::INT,
               $1:program::INT,
               $1:program_name::String,
               $1:program_tags::String,
               $1:host_names,
               $1:tagline::String,
               $1:start_time::TIMESTAMP_LTZ
        from @owlmtn.stage.KEXP_PUBLIC
    )
    pattern = 'stage/kexp/shows/.*',
    file_format = (type = json);




