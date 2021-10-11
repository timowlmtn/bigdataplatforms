copy into @owlmtn.stage.KEXP_PUBLIC/export/import_kexp_show.parquet
    from (
        select LOAD_ID,
               FILENAME,
               FILE_ROW_NUMBER,
               SHOW_ID,
               PROGRAM_ID,
               PROGRAM_NAME,
               PROGRAM_TAGS,
               HOST_NAMES,
               TAGLINE,
               START_TIME::STRING,
               DW_CREATE_DATE::STRING,
               DW_CREATE_USER,
               DW_UPDATE_DATE::STRING,
               DW_UPDATE_USER
        from STAGE.IMPORT_KEXP_SHOW
            )
    OVERWRITE = TRUE
    file_format = (type = parquet);