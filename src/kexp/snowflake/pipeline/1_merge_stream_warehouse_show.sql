merge into WAREHOUSE.DIM_SHOW dim
    using STAGE.STREAM_IMPORT_KEXP_SHOW_CDC str on dim.SHOW_ID = str.SHOW_ID
    when matched and str.metadata$action = 'DELETE' AND metadata$isupdate = 'FALSE'
        then delete
    when matched and str.metadata$action = 'INSERT' AND metadata$isupdate = 'TRUE'
        then UPDATE SET
        dim.LOAD_ID = str.LOAD_ID
        , dim.SHOW_ID = str.SHOW_ID
        , dim.PROGRAM_ID = str.PROGRAM_ID
        , dim.PROGRAM_NAME = str.PROGRAM_NAME
        , dim.PROGRAM_TAGS = str.PROGRAM_TAGS
        , dim.HOST_NAMES = str.HOST_NAMES
        , dim.TAGLINE = str.TAGLINE
        , dim.START_TIME = str.START_TIME
        , DW_UPDATE_DATE = current_timestamp
        , DW_UPDATE_USER = current_user
    when not matched and metadata$action = 'INSERT' and metadata$isupdate = 'FALSE'
        then INSERT (LOAD_ID, SHOW_ID, PROGRAM_ID, PROGRAM_NAME, PROGRAM_TAGS, HOST_NAMES, TAGLINE, START_TIME)
        values (str.LOAD_ID, str.SHOW_ID, str.PROGRAM_ID, str.PROGRAM_NAME, str.PROGRAM_TAGS, str.HOST_NAMES,
                str.TAGLINE, str.START_TIME);
