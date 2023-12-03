CREATE PIPE IF NOT EXISTS LANDING_ZONE.PIPE_SEATGEEK_EVENT
    AUTO_INGEST = TRUE
    ERROR_INTEGRATION = S3_LAKE_KEXP_NOTIFICATION
    AS
COPY INTO LANDING_ZONE.PIPE_SEATGEEK_EVENT (
    {% - FOR COL, COLUMN_MAPPING IN PROPERTIES.ITEMS() %}
            {% IF NOT COLUMN_MAPPING['IS_IDENTITY'] %}
                {{ COLUMN_MAPPING['COLUMN_NAME'] }}
                {% IF NOT LOOP.LAST %}, { % ENDIF %}
    {% ENDIF %}
    {% - ENDFOR %}
    )
    FROM (SELECT {%- FOR COL, COLUMN_MAPPING IN PROPERTIES.ITEMS() %}
              {% IF NOT COLUMN_MAPPING['IS_IDENTITY'] %}
              {% IF COLUMN_MAPPING['DEFAULT'] IS DEFINED %}{{ COLUMN_MAPPING['DEFAULT'] }} {{ COL }}
              {% ELSE %}$1:{{ COL }}::{{ COLUMN_MAPPING['DATA_TYPE'] }} {{ COL }}{% ENDIF %}{% IF NOT LOOP.LAST %}, {% ENDIF %}
              {% ENDIF %}
              {%- ENDFOR %}
          FROM @{{ SCHEMA_NAME }}.STAGE_{{ TABLE_NAME }})
    FILE_FORMAT = (TYPE = 'JSON')
    PATTERN = '.*.JSON';


show pipes;

LIST @LANDING_ZONE.STAGE_SEATGEEK_EVENT;


select value:id,
       value:announce_date::date,
       value:created_at::timestamp,
       value:datetime_local::timestamp,
       value:performers,
       value:popularity,
       value:score,
       value:short_title::string,
       value:status::string,
       value:taxonomies,
       value:title::string,
       value:type::string,
       value:url::string,
       value:venue,
       value:metro_code,
       value:name,
       value:num_upcoming_events,
       value:postal_code,
       value:score,
       value:slug,
       value:state,
       value:timezone,
       value                    event_value,
       stg.$1                   LANDING_ZONE_VALUE,
       metadata$filename        LANDING_ZONE_FILENAME,
       metadata$file_row_number LANDING_ZONE_FILE_ROW_NUMBER,
       *
from @LANDING_ZONE.STAGE_SEATGEEK_EVENT (
         pattern =>'stage/seatgeek/events/.*',
         file_format => LANDING_ZONE.JSON) stg,
     lateral flatten(input => $1:events) event
;


-- This SQL shows the logic used in  STAGE.PROCEDURE_STG_NESTED_AUTHORIZATION_ITEM();
with latest_version as (select coalesce(max(AF02X21_MODIFIED_TIMESTAMP), '2022-01-01'::timestamp) dw_timestamp
                        from STAGE.STG_NESTED_AUTHORIZATION_ITEM)
select item.value:SourceID::string id
     , INGESTION_ID
     , SOURCE_ID                   authorization_source_id
     , item.value:SourceID::string source_id
from _LANDING_ZONE.DM_NESTED_AUTHORIZATION dm
         inner join latest_version on dm.AF02X21_HIDDEN = FALSE and
                                      dm.AF02X21_MODIFIED_TIMESTAMP > latest_version.dw_timestamp,
     lateral flatten(input => dm.ITEMS) item
where item.value:SourceID::string is not NULL;
;

select $1:id::NUMBER            id,
--                  $1:program::NUMBER           program,
--                  $1:program_name::TEXT        program_name,
--                  $1:program_tags::TEXT        program_tags,
--                  $1:host_names::VARIANT       host_names,
--                  $1:tagline::TEXT             tagline,
--                  $1:start_time::TIMESTAMP_LTZ start_time,
--                  CURRENT_TIMESTAMP()          landing_zone_create_date,
--                  CURRENT_USER()               landing_zone_create_user,
--                  CURRENT_TIMESTAMP()          landing_zone_update_date,
--                  CURRENT_USER()               landing_zone_update_user,
--                  FALSE                        landing_zone_hidden,
       metadata$filename        landing_zone_filename,
       metadata$file_row_number landing_zone_file_row_number,
       $1                       landing_zone_raw
from @LANDING_ZONE.STAGE_SEATGEEK_EVENT FILE_FORMAT = (type = 'JSON')
    PATTERN = '.*.json'
;


copy into LANDING_ZONE.IMPORT_SHOW (
                                    SHOW_ID,
                                    PROGRAM_ID,
                                    PROGRAM_NAME,
                                    PROGRAM_TAGS,
                                    HOST_NAMES,
                                    TAGLINE,
                                    START_TIME,
                                    LANDING_ZONE_CREATE_DATE,
                                    LANDING_ZONE_CREATE_USER,
                                    LANDING_ZONE_UPDATE_DATE,
                                    LANDING_ZONE_UPDATE_USER,
                                    landing_zone_hidden,
                                    landing_zone_filename,
                                    landing_zone_file_row_number,
                                    landing_zone_raw
    )
    from (select $1:id::NUMBER                id,
                 $1:program::NUMBER           program,
                 $1:program_name::TEXT        program_name,
                 $1:program_tags::TEXT        program_tags,
                 $1:host_names::VARIANT       host_names,
                 $1:tagline::TEXT             tagline,
                 $1:start_time::TIMESTAMP_LTZ start_time,
                 CURRENT_TIMESTAMP()          landing_zone_create_date,
                 CURRENT_USER()               landing_zone_create_user,
                 CURRENT_TIMESTAMP()          landing_zone_update_date,
                 CURRENT_USER()               landing_zone_update_user,
                 FALSE                        landing_zone_hidden,
                 metadata$filename            landing_zone_filename,
                 metadata$file_row_number     landing_zone_file_row_number,
                 $1                           landing_zone_raw
          from @LANDING_ZONE.STAGE_IMPORT_SHOW)
    FILE_FORMAT = (type = 'JSON')
    PATTERN = '.*.json'