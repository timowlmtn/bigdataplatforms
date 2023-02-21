copy into @owlmtn.stage.KEXP_PUBLIC/export/import_kexp_playlist
    from (
        select PLAYLIST_ID,
               PLAY_TYPE,
               AIRDATE,
               ALBUM,
               ARTIST,
               SONG,
               SHOW_ID,
               PROGRAM_ID,
               PROGRAM_NAME,
               PROGRAM_TAGS,
               HOST_NAMES,
               TAGLINE,
               START_TIME,
               RELEASE_DATE
        from ANALYTICS.VIEW_KEXP_PLAYLIST_SHOW
        where song is not null
          and artist is not null
          and AIRDATE is not null
    )
    OVERWRITE = TRUE
    file_format = (type = csv COMPRESSION = NONE field_optionally_enclosed_by = '"');

