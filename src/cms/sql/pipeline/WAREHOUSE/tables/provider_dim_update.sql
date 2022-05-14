---- Update the record and mark the tip as ACTIVE and the most recent as inactive
update WAREHOUSE.PROVIDER_DIM new_data
set new_data.SCD_IS_ACTIVE     = update_logic.NEW_ISACTIVE,
    new_data.SCD_FROM_DATETIME = update_logic.new_EFFECTIVE_DATETIME,
    new_data.SCD_TO_DATETIME   = update_logic.new_end_datetime,
    new_data.DW_MODIFIED_DATE  = current_timestamp()
from (
         with updated_gui as (
             select max(PROVIDER_KEY) PROVIDER_KEY, ID, SCD_HASH_ID, SCD_IS_ACTIVE
             from WAREHOUSE.PROVIDER_DIM
             where SCD_FROM_DATETIME is null
             group by ID, SCD_HASH_ID, SCD_IS_ACTIVE
         )
         select current_row.PROVIDER_KEY,
                current_row.SCD_IS_ACTIVE    as old_active,

                -- If it is a new record value then set to active
                case
                    when current_row.PROVIDER_KEY = updated_gui.PROVIDER_KEY
                        then TRUE
                    else FALSE end           as NEW_ISACTIVE,

                -- If it is an older value, leave as is, otherwise, set active start date
                -- to the current time, also squash any stray null effective end dates
                current_row.SCD_FROM_DATETIME   old_EFFECTIVE_DATETIME,
                case
                    when current_row.PROVIDER_KEY = updated_gui.PROVIDER_KEY
                        then STAGE_FILE_DATE
                    else coalesce(current_row.SCD_FROM_DATETIME, STAGE_FILE_DATE)
                    end                      as new_EFFECTIVE_DATETIME,

                current_row.SCD_TO_DATETIME     old_end_datetime,

                case
                    when current_row.PROVIDER_KEY = updated_gui.PROVIDER_KEY
                        then to_timestamp_ltz('2999-12-31 00:00:00')
                    else STAGE_FILE_DATE end as new_end_datetime,
                current_row.SCD_HASH_ID
         from WAREHOUSE.PROVIDER_DIM current_row
                  inner join updated_gui
                             on updated_gui.ID = current_row.ID
     ) update_logic
where new_data.PROVIDER_KEY = update_logic.PROVIDER_KEY;
