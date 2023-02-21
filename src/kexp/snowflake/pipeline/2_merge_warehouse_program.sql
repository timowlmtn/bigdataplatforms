merge into WAREHOUSE.DIM_RADIO_PROGRAM tar
    using (with station as (select DIM_RADIO_STATION_KEY, STATION_NAME
                            from WAREHOUSE.DIM_RADIO_STATION)
           select show.LOAD_ID
                , show.FILENAME
                , show.FILE_ROW_NUMBER
                , ID
                , DESCRIPTION
                , IS_ACTIVE
                , NAME
                , TAGS
                , URI
                , sta.DIM_RADIO_STATION_KEY
           from STAGE.IMPORT_KEXP_PROGRAM show
                    inner join station sta on 'KEXP' = sta.STATION_NAME) str on tar.PROGRAM_ID = str.ID
    when matched
        then UPDATE SET
        tar.DESCRIPTION = str.DESCRIPTION
        , tar.DW_CURRENT = str.IS_ACTIVE
        , tar.NAME = str.NAME
        , tar.TAGS = str.TAGS
        , tar.WEBSITE_URL = str.URI
        , tar.DIM_RADIO_STATION_KEY = str.DIM_RADIO_STATION_KEY
        , DW_UPDATE_DATE = current_timestamp
        , DW_UPDATE_USER = current_user
    when not matched
        then
        INSERT (LOAD_ID, PROGRAM_ID, DESCRIPTION, DW_CURRENT, NAME, TAGS, WEBSITE_URL, DIM_RADIO_STATION_KEY)
            values ( LOAD_ID, ID, DESCRIPTION
                   , IS_ACTIVE, NAME
                   , TAGS, URI
                   , DIM_RADIO_STATION_KEY);
