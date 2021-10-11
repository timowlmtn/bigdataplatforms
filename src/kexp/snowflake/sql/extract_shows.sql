copy into @owlmtn.stage.KEXP_PUBLIC/export/import_kexp_show
    from (
        select LOAD_ID,
               FILENAME,
               FILE_ROW_NUMBER,
               SHOW_ID,
               PROGRAM_ID,
               PROGRAM_NAME,
               PROGRAM_TAGS,
               HOST_NAMES::STRING,
               TAGLINE,
               START_TIME::STRING,
               DW_CREATE_DATE::STRING,
               DW_CREATE_USER,
               DW_UPDATE_DATE::STRING,
               DW_UPDATE_USER
        from STAGE.IMPORT_KEXP_SHOW
            )
    OVERWRITE = TRUE
    file_format = (type = csv COMPRESSION = NONE field_optionally_enclosed_by = '"');

copy into @owlmtn.stage.KEXP_PUBLIC/export/import_kexp_show_header
    from (
        select listagg(column_name, ',')
                       within group (order by ordinal_position)
        from information_schema.columns
        where table_schema = 'STAGE'
          and table_name = 'IMPORT_KEXP_SHOW')
    OVERWRITE = TRUE
    file_format = (type = csv COMPRESSION = NONE);

