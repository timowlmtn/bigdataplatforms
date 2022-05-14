-- Query the table
select count(*)
     , SCD_IS_ACTIVE
     , SCD_FROM_DATETIME
     , SCD_TO_DATETIME
     , STAGE_FILE_DATE
     , STAGE_FILENAME
from WAREHOUSE.PROVIDER_DIM
group by STAGE_FILENAME
       , STAGE_FILE_DATE
       , SCD_IS_ACTIVE
       , SCD_FROM_DATETIME
       , SCD_TO_DATETIME;


-- Find duplicates
select dw.ID, count(stg.STAGE_FILE_ROW_NUMBER), count(distinct dw.id)
from STAGE.CMS_PROVIDER stg
left outer join WAREHOUSE.PROVIDER_DIM dw on stg.ID = dw.ID
group by dw.ID
having count(stg.STAGE_FILE_ROW_NUMBER) > 1
order by 2 desc;


-- 143 records here that are duplicates - check!
select *
from CMS_PROVIDER where id = '1326534264';

-- Create a MERGE statement that will dedup and track SCD
with sql_fragments as (
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
        ),
             scd_metadata as (
                 select ORDINAL_POSITION, DATA_TYPE, COLUMN_NAME
                 from INFORMATION_SCHEMA.COLUMNS
                 where TABLE_SCHEMA = 'WAREHOUSE'
                   and TABLE_NAME = 'PROVIDER_DIM'
                   and COLUMN_NAME not like 'DW_%'
                   and COLUMN_NAME not like 'SCD_%'
                   AND COLUMN_NAME not like '%_KEY'
                   AND COLUMN_NAME not like 'STAGE_%'
                 order by ORDINAL_POSITION
             )
        select listagg(md.COLUMN_NAME, '\n  ,') within group ( order by md.ORDINAL_POSITION )               columns
             , listagg('  stg.' || md.COLUMN_NAME, '\n  ,') within group ( order by md.ORDINAL_POSITION )   stage_columns
             , listagg('  tar.' || md.COLUMN_NAME || ' = src.' || md.COLUMN_NAME, '\n  ,')
                       within group ( order by md.ORDINAL_POSITION )                                        update_columns
             , listagg('  src.' || md.COLUMN_NAME, '\n  ,') within group ( order by md.ORDINAL_POSITION )   insert_columns
             , listagg('  stg.' || scd.COLUMN_NAME, '\n  ,') within group ( order by scd.ORDINAL_POSITION ) scd_columns
             , listagg('  src.' || scd.COLUMN_NAME, '\n  ,')
                       within group ( order by scd.ORDINAL_POSITION )                                       src_scd_columns

        from metadata md
                 left outer join scd_metadata scd on md.column_name = scd.column_name
    )
    select 'with tip as (\n' ||
           '     select ID, MAX(DW_MODIFIED_DATE) last_modified\n' ||
           '     from  WAREHOUSE.PROVIDER_DIM\n' ||
           '     where SCD_IS_ACTIVE = TRUE\n' ||
           '     group by ID)' ||
           'SELECT\n' || stage_columns || '\n' ||
           '  , hash(' || scd_columns || ') SCD_HASH_ID' ||
           '  , row_number() over ( partition by stg.ID order by stg.STAGE_FILE_DATE desc ) row_number' ||
           ' FROM\n' ||
           ' STAGE.CMS_PROVIDER stg\n' ||
           '    left outer join tip on tip.ID = stg.ID\n' ||
           '    where stg.DW_MODIFIED_DATE > coalesce(tip.last_modified, ''1900-01-01'')\n' ||
           '      and DW_IS_ACTIVE\n' ||
           '    qualify row_number = 1\n'
               stage_sql,
           columns,
           update_columns,
           insert_columns,
           scd_columns,
           src_scd_columns
    from all_columns
)
select 'merge into WAREHOUSE.PROVIDER_DIM tar\n' ||
       ' using (\n' ||
       '       ' || stage_sql ||
       ' )' ||
       'as src on src.ID = tar.ID and src.SCD_HASH_ID = tar.SCD_HASH_ID and tar.SCD_IS_ACTIVE = True \n' ||
       ' when matched then update set\n' ||
       update_columns || '\n' ||
       ' when not matched then insert (' || columns || '\n  ,\n  SCD_IS_ACTIVE, SCD_HASH_ID)' ||
       '     values (' || insert_columns || ', false, hash(' || src_scd_columns || ')\n);'
from sql_fragments;

