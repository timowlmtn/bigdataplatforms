insert into STAGE.COPY_STATISTICS(TABLE_NAME, QUERY_ID, RESULT)
select 'CMS_PROVIDER'
    , last_query_id()
    , object_construct(*)
    from table(result_scan(last_query_id()));

