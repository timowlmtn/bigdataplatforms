copy into stage.IMPORT_KEXP_PLAYLIST (FILENAME,
                                      FILE_ROW_NUMBER,
                                      PLAYLIST_ID,
                                      PLAY_TYPE,
                                      AIRDATE,
                                      ALBUM,
                                      ARTIST,
                                      SONG,
                                      SHOW_ID,
                                      COMMENT,
                                      image_uri,
                                      labels,
                                      release_date)
    from (
        select metadata$filename filename,
               metadata$file_row_number,
               $1:id::Int,
               $1:play_type::String,
               $1:airdate::TIMESTAMP_LTZ,
               $1:album::String,
               $1:artist::String,
               $1:song::String,
               $1: show::INT,
               $1: comment::String,
               $1:image_uri::String,
               $1:labels,
               $1:release_date
        from @owlmtn.stage.KEXP_PUBLIC
    )
    pattern = 'stage/kexp/playlists/.*',
    file_format = (type = json);


