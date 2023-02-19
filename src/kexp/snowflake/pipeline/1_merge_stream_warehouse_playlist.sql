merge into WAREHOUSE.FACT_PLAYLIST fact
    using (
        with show as (
            select DIM_SHOW_KEY, SHOW_ID
            from WAREHOUSE.DIM_SHOW
        ), station as (
            select DIM_STATION_KEY
            from WAREHOUSE.DIM_STATION
            where STATION_NAME = 'KEXP'
        )
        select sh.DIM_SHOW_KEY, str.*
        from STAGE.STREAM_IMPORT_KEXP_PLAYLIST_CDC str
        inner join show sh on str.show_id = sh.SHOW_ID
        cross join station
    )
    on fact.PLAYLIST_ID = str.PLAYLIST_ID
    when matched and str.metadata$action = 'DELETE' AND metadata$isupdate = 'FALSE'
        then delete
    when matched and str.metadata$action = 'INSERT' AND metadata$isupdate = 'TRUE'
        then UPDATE SET
        fact.LOAD_ID = str.LOAD_ID,
        fact.PLAYLIST_ID = str.PLAYLIST_ID,
        fact.PLAY_TYPE = str.PLAY_TYPE,
        fact.AIRDATE = str.AIRDATE,
        fact.ALBUM = str.ALBUM,
        fact.ARTIST = str.ARTIST,
        fact.SONG = str.SONG,
        fact.SHOW_ID = str.SHOW_ID,
        fact.COMMENT = str.COMMENT,
        fact.IMAGE_URI = str.IMAGE_URI,
        fact.LABELS = str.LABELS,
        fact.RELEASE_DATE = str.RELEASE_DATE,

        DW_UPDATE_DATE = current_timestamp,
        DW_UPDATE_USER = current_user
    when not matched and metadata$action = 'INSERT' and metadata$isupdate = 'FALSE'
        then INSERT (LOAD_ID,
                     PLAYLIST_ID,
                     PLAY_TYPE,
                     AIRDATE,
                     ALBUM,
                     ARTIST,
                     SONG,
                     SHOW_ID,
                     COMMENT,
                     IMAGE_URI,
                     LABELS,
                     RELEASE_DATE)
        values (str.LOAD_ID,
                str.PLAYLIST_ID,
                str.PLAY_TYPE,
                str.AIRDATE,
                str.ALBUM,
                str.ARTIST,
                str.SONG,
                str.SHOW_ID,
                str.COMMENT,
                str.IMAGE_URI,
                str.LABELS,
                str.RELEASE_DATE);