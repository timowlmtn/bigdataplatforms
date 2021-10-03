insert into WAREHOUSE.dim_kexp_show(LOAD_ID,
                                    SHOW_ID,
                                    PROGRAM_ID,
                                    PROGRAM_NAME,
                                    PROGRAM_TAGS,
                                    HOST_NAMES,
                                    TAGLINE,
                                    START_TIME)
select stg.load_id,
       value:id::INT,
       value:program::INT,
       value:program_name::String,
       value:program_tags::String,
       value:host_names,
       value:tagline::String,
       value:start_time::TIMESTAMP_LTZ
from stage.raw_kexp_show stg
left outer join WAREHOUSE.dim_kexp_show existing on value:id::INT = existing.SHOW_ID
where stg.load_id > (select coalesce(max(load_id), 0) from WAREHOUSE.dim_kexp_show)
and existing.SHOW_ID is null;
