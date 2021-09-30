copy into stage.IMPORT_KEXP_PLAYLIST (FILENAME, FILE_ROW_NUMBER, PLAY_TYPE, AIRDATE, ALBUM, ARTIST, SONG)
    from (
        select metadata$filename                filename,
               metadata$file_row_number,
               tab.value:play_type::STRING      play_type,
               tab.value:airdate::TIMESTAMP_LTZ airdate,
               tab.value:album::STRING          album,
               tab.value:artist::STRING         artist,
               tab.value:song::STRING           song
        from @owlmtn.stage.AZRIUS_STAGE_TEST (
                 pattern =>'stage/kexp/.*',
                 file_format => stage.json_file_format) stg,
             table (flatten(stg.$1:results)) tab
    )
    pattern = 'stage/kexp/.*',
    file_format = (type = json);

