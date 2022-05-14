-- Create a MERGE statement
with all_columns as (
    with metadata as (
        select ORDINAL_POSITION, DATA_TYPE, COLUMN_NAME
        from INFORMATION_SCHEMA.COLUMNS
        where TABLE_SCHEMA = 'WAREHOUSE'
          and TABLE_NAME = 'PROVIDER_DIM'
          and COLUMN_NAME not like 'DW_%'
          and COLUMN_NAME not like 'SCD_%'
          AND COLUMN_NAME not like '%_KEY'
        order by ORDINAL_POSITION
    )
    select listagg('  stg.' || COLUMN_NAME, '\n  ,')
                   within group ( order by ORDINAL_POSITION )
               select_columns
    from metadata
)
select 'with tip as (\n' ||
       '     select ID, MAX(DW_MODIFIED_DATE) last_modified\n' ||
       '     from  WAREHOUSE.PROVIDER_DIM\n' ||
       '     where SCD_IS_ACTIVE = TRUE\n'||
       '     group by ID)' ||
       'SELECT\n' || select_columns || '\n' ||
       ' FROM\n' ||
       ' STAGE.CMS_PROVIDER stg'||
       ' left outer join tip on tip.ID = stg.ID;'
from all_columns;


--- Output
with tip as (
     select ID, MAX(DW_MODIFIED_DATE) last_modified
     from  WAREHOUSE.PROVIDER_DIM
     where SCD_IS_ACTIVE = TRUE
     group by ID)SELECT
  stg.ID
  ,  stg.NPI
  ,  stg.SOURCE
  ,  stg.IND_PAC_ID
  ,  stg.IND_ENRL_ID
  ,  stg.LST_NM
  ,  stg.FRST_NM
  ,  stg.MID_NM
  ,  stg.SUFF
  ,  stg.GNDR
  ,  stg.CRED
  ,  stg.MED_SCH
  ,  stg.GRD_YR
  ,  stg.PRI_SPEC
  ,  stg.SEC_SPEC_1
  ,  stg.SEC_SPEC_2
  ,  stg.SEC_SPEC_3
  ,  stg.SEC_SPEC_4
  ,  stg.SEC_SPEC_ALL
  ,  stg.ORG_NM
  ,  stg.ORG_PAC_ID
  ,  stg.NUM_ORG_MEM
  ,  stg.ADR_LN_1
  ,  stg.ADR_LN_2
  ,  stg.LN_2_SPRS
  ,  stg.CTY
  ,  stg.ST
  ,  stg.ZIP
  ,  stg.PHN_NUMBR
  ,  stg.HOSP_AFL_1
  ,  stg.HOSP_AFL_LBN_1
  ,  stg.HOSP_AFL_2
  ,  stg.HOSP_AFL_LBN_2
  ,  stg.HOSP_AFL_3
  ,  stg.HOSP_AFL_LBN_3
  ,  stg.HOSP_AFL_4
  ,  stg.HOSP_AFL_LBN_4
  ,  stg.HOSP_AFL_5
  ,  stg.HOSP_AFL_LBN_5
  ,  stg.IND_ASSGN
  ,  stg.GRP_ASSGN
  ,  stg.ADRS_ID
  ,  stg.STAGE_FILENAME
  ,  stg.STAGE_FILE_ROW_NUMBER
  ,  stg.STAGE_FILE_DATE
 FROM
 STAGE.CMS_PROVIDER stg left outer join tip on tip.ID = stg.ID;