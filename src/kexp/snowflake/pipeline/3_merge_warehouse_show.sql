merge into WAREHOUSE.FACT_RADIO_SHOW dim
    using (
        with station as (
            select DIM_RADIO_STATION_KEY, STATION_NAME
            from WAREHOUSE.DIM_RADIO_STATION
        ),
            program as (
                select DIM_RADIO_PROGRAM_KEY, PROGRAM_ID
                from WAREHOUSE.DIM_RADIO_PROGRAM
            )
        select show.LOAD_ID
             , show.SHOW_ID
             , show.PROGRAM_ID
             , show.PROGRAM_NAME
             , show.PROGRAM_TAGS
             , show.HOST_NAMES
             , show.TAGLINE
             , show.START_TIME
             , sta.DIM_RADIO_STATION_KEY
             , pro.DIM_RADIO_PROGRAM_KEY
        from
        STAGE.IMPORT_KEXP_SHOW show
        inner join station sta on 'KEXP' = sta.STATION_NAME
        inner join program pro on show.PROGRAM_ID = pro.PROGRAM_ID
        ) str on dim.SHOW_ID = str.SHOW_ID
    when not matched
        then INSERT (DIM_RADIO_STATION_KEY, DIM_RADIO_PROGRAM_KEY, LOAD_ID, SHOW_ID, PROGRAM_ID, PROGRAM_NAME, PROGRAM_TAGS, HOST_NAMES, TAGLINE, START_TIME)
        values (str.DIM_RADIO_STATION_KEY, DIM_RADIO_PROGRAM_KEY, str.LOAD_ID, str.SHOW_ID, str.PROGRAM_ID, str.PROGRAM_NAME, str.PROGRAM_TAGS, str.HOST_NAMES,
                str.TAGLINE, str.START_TIME);
