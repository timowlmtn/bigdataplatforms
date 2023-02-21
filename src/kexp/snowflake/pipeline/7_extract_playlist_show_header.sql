copy into @owlmtn.stage.KEXP_PUBLIC/export/import_kexp_playlist_header
    from (
        select listagg(column_name, ',')
                       within group (order by ordinal_position)
        from information_schema.columns
        where table_schema = 'ANALYTICS'
          and table_name = 'VIEW_KEXP_PLAYLIST_SHOW'
         and COLUMN_NAME in (
         'PLAYLIST_ID',
               'PLAY_TYPE',
               'AIRDATE',
               'ALBUM',
               'ARTIST',
               'SONG',
               'SHOW_ID',
               'PROGRAM_ID',
               'PROGRAM_NAME',
               'PROGRAM_TAGS',
               'HOST_NAMES',
               'TAGLINE',
               'START_TIME',
               'RELEASE_DATE'
            )
    )
    OVERWRITE = TRUE
    file_format = (type = csv COMPRESSION = NONE);