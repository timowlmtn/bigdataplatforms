copy into @owlmtn.stage.KEXP_PUBLIC/export/import_kexp_playlist
    from (
        select LOAD_ID,
               FILENAME,
               FILE_ROW_NUMBER,
               PLAYLIST_ID,
               PLAY_TYPE,
               AIRDATE::STRING,
               ALBUM,
               ARTIST,
               SONG,
               SHOW_ID,
               DW_CREATE_DATE::STRING,
               DW_CREATE_USER,
               DW_UPDATE_DATE::STRING,
               DW_UPDATE_USER
        from STAGE.IMPORT_KEXP_PLAYLIST
            )
    OVERWRITE = TRUE
    file_format = (type = csv COMPRESSION = NONE field_optionally_enclosed_by = '"');

copy into @owlmtn.stage.KEXP_PUBLIC/export/import_kexp_playlist_header
    from (
        select listagg(column_name, ',')
                       within group (order by ordinal_position)
        from information_schema.columns
        where table_schema = 'STAGE'
          and table_name = 'IMPORT_KEXP_PLAYLIST')
    OVERWRITE = TRUE
    file_format = (type = csv COMPRESSION = NONE);