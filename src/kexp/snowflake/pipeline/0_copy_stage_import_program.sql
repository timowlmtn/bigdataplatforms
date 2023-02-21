/*

SELECT                  $1:id::integer,
                 $1:description::string,
                 $1:is_active::boolean,
                 $1:name::string,
                 $1:tags::string,
                 $1:uri::string
FROM @stage.STAGE_KEXP_PROGRAM

    (file_format => 'STAGE.JSON_FILE_FORMAT',
     pattern => '.*' ) t;
 */
copy into stage.IMPORT_KEXP_PROGRAM (FILENAME,
                                     FILE_ROW_NUMBER,
                                     ID,
                                     DESCRIPTION,
                                     IS_ACTIVE,
                                     NAME,
                                     TAGS,
                                     URI)
    from (select metadata$filename filename,
                 metadata$file_row_number,
                 $1:id::integer,
                 $1:description::string,
                 $1:is_active::boolean,
                 $1:name::string,
                 $1:tags::string,
                 $1:uri::string
          from @stage.STAGE_KEXP_PROGRAM src)
    pattern = 'stage/kexp/programs/.*.jsonl'
    file_format = (type = json);


