merge into WAREHOUSE.DIM_STATION tar
    using (select 'KEXP'                                                                                     STATION_NAME,
                  97.3                                                                                       FREQUENCY,
                  'Seattle, WA'                                                                              LOCATION,
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
        tar.API = src.API,
        tar.URI = src.URI,
        tar.IS_ACTIVE = src.is_active
    when not matched then insert (STATION_NAME,
                                  FREQUENCY,
                                  LOCATION,
                                  OWNER,
                                  FORMAT,
                                  API,
                                  URI,
                                  IS_ACTIVE)
        values (src.STATION_NAME,
                src.FREQUENCY,
                src.LOCATION,
                src.OWNER,
                src.FORMAT,
                src.API,
                src.URI,
                src.IS_ACTIVE)
;