merge into WAREHOUSE.FACT_RADIO_PLAYLIST fact
    using (
        with station as (
            select DIM_RADIO_STATION.DIM_RADIO_STATION_KEY, STATION_NAME
            from WAREHOUSE.DIM_RADIO_STATION
        )
        select DIM_CALENDAR_KEY, DIM_RADIO_STATION_KEY
             , str.LOAD_ID,
               str.PLAYLIST_ID, str.PLAY_TYPE, str.AIRDATE, str.ALBUM, str.ARTIST, str.SONG, str.SHOW_ID,
               str.COMMENT, str.IMAGE_URI, str.LABELS, str.RELEASE_DATE
        from STAGE.IMPORT_KEXP_PLAYLIST str
        inner join station sta on 'KEXP' = sta.STATION_NAME
        inner join WAREHOUSE.DIM_CALENDAR cal on AIRDATE::date = cal.DATE
    ) str

    on fact.PLAYLIST_ID = str.PLAYLIST_ID

    when not matched
        --and metadata$action = 'INSERT' and metadata$isupdate = 'FALSE'
        then INSERT (DIM_RADIO_STATION_KEY,
                     DIM_CALENDAR_KEY,
                     LOAD_ID,
                     PLAYLIST_ID,
                     PLAY_TYPE,
                     AIRDATE,
                     ALBUM,
                     ARTIST,
                     SONG,
                     COMMENT,
                     IMAGE_URI,
                     LABELS,
                     RELEASE_DATE)
        values (str.DIM_RADIO_STATION_KEY,
                str.DIM_CALENDAR_KEY,
                str.LOAD_ID,
                str.PLAYLIST_ID,
                str.PLAY_TYPE,
                str.AIRDATE,
                str.ALBUM,
                str.ARTIST,
                str.SONG,
                str.COMMENT,
                str.IMAGE_URI,
                str.LABELS,
                str.RELEASE_DATE);