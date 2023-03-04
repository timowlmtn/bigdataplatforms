merge into WAREHOUSE.DIM_RADIO_STATION tar
    using (select 'KEXP'                                                                                     STATION_NAME,
                  97.3                                                                                       FREQUENCY,
                  'Seattle, WA'                                                                              LOCATION,
                  'US/Pacific'                                                                               TIMEZONE,
                  'Friends of KEXP'                                                                          OWNER,
                  'A wide variety of genres such as indie rock, hip-hop, electronic, world music, and more.' FORMAT,
                  'https://api.kexp.org/v2/'                                                                 API,
                  'https://www.kexp.org/'                                                                    URI,
                  true                                                                                       IS_ACTIVE)
        as src on src.STATION_NAME = tar.STATION_NAME
    when matched then update set
        tar.FREQUENCY = src.FREQUENCY,
        tar.LOCATION = src.LOCATION,
        tar.OWNER = src.OWNER,
        tar.TIMEZONE = src.TIMEZONE,
        tar.API = src.API,
        tar.URI = src.URI,
        tar.DW_CURRENT = src.is_active,
        tar.DW_UPDATE_DATE = current_timestamp,
        tar.DW_UPDATE_USER = current_user
    when not matched then insert (STATION_NAME,
                                  FREQUENCY,
                                  LOCATION,
                                  TIMEZONE,
                                  OWNER,
                                  FORMAT,
                                  API,
                                  URI,
                                  DW_CURRENT)
        values (src.STATION_NAME,
                src.FREQUENCY,
                src.LOCATION,
                src.TIMEZONE,
                src.OWNER,
                src.FORMAT,
                src.API,
                src.URI,
                src.IS_ACTIVE)
;