insert into WAREHOUSE.DIM_KEXP_SHOW(SHOW_ID, PROGRAM_ID, PROGRAM_NAME, PROGRAM_TAGS, HOST_NAMES, TAGLINE, START_TIME,
                                    LOAD_ID)
select SHOW_ID,
       PROGRAM_ID,
       PROGRAM_NAME,
       PROGRAM_TAGS,
       HOST_NAMES,
       TAGLINE,
       START_TIME,
       max(LOAD_ID)
from STAGE.IMPORT_KEXP_SHOW
where SHOW_ID is not null
and START_TIME is not null
group by SHOW_ID, PROGRAM_ID, PROGRAM_NAME, PROGRAM_TAGS, HOST_NAMES, TAGLINE, START_TIME
;