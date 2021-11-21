copy into stage.raw_kexp_show (filename, file_row_number, value)
    from (
        select metadata$filename filename,
               metadata$file_row_number,
               stg."$1"
        from @owlmtn.stage.AZRIUS_STAGE_TEST stg)
    pattern = 'stage/kexp/shows/.*',
                        file_format = (type = json);

