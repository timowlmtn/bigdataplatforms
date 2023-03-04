select *
from STAGE.IMPORT_KEXP_SHOW
limit 1;


select PROGRAM_NAME, count(*) counts, min(START_TIME)::date min, max(START_TIME)::date max
from STAGE.IMPORT_KEXP_SHOW
group by PROGRAM_NAME
order by PROGRAM_NAME;

