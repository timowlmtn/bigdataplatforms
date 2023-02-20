select DIM_SHOW_KEY
     , PROGRAM_ID
     , show_id
     , START_TIME
     , lag(START_TIME) over (partition by SHOW_ID order by START_TIME) last_time
     , row_number() over (partition by PROGRAM_ID order by START_TIME desc) row_number
from WAREHOUSE.DIM_SHOW
where START_TIME > dateadd(day, -7, current_date)
and PROGRAM_ID = 32;