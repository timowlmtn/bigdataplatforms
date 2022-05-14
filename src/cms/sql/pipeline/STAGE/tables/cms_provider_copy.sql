-- Copy the SQL
copy into STAGE.CMS_PROVIDER (ID,
                              SOURCE,
                              NPI,
                              IND_PAC_ID,
                              IND_ENRL_ID,
                              LST_NM,
                              FRST_NM,
                              MID_NM,
                              SUFF,
                              GNDR,
                              CRED,
                              MED_SCH,
                              GRD_YR,
                              PRI_SPEC,
                              SEC_SPEC_1,
                              SEC_SPEC_2,
                              SEC_SPEC_3,
                              SEC_SPEC_4,
                              SEC_SPEC_ALL,
                              ORG_NM,
                              ORG_PAC_ID,
                              NUM_ORG_MEM,
                              ADR_LN_1,
                              ADR_LN_2,
                              LN_2_SPRS,
                              CTY,
                              ST,
                              ZIP,
                              PHN_NUMBR,
                              HOSP_AFL_1,
                              HOSP_AFL_LBN_1,
                              HOSP_AFL_2,
                              HOSP_AFL_LBN_2,
                              HOSP_AFL_3,
                              HOSP_AFL_LBN_3,
                              HOSP_AFL_4,
                              HOSP_AFL_LBN_4,
                              HOSP_AFL_5,
                              HOSP_AFL_LBN_5,
                              IND_ASSGN,
                              GRP_ASSGN,
                              ADRS_ID,
                              STAGE_FILENAME,
                              STAGE_FILE_ROW_NUMBER,
                              STAGE_FILE_DATE)
    from (
        select t."$1"::TEXT              NPI
             , 'CMS'                     SOURCE
             , t."$1"::TEXT              NPI
             , t."$2"::TEXT              IND_PAC_ID
             , t."$3"::TEXT              IND_ENRL_ID
             , t."$4"::TEXT              LST_NM
             , t."$5"::TEXT              FRST_NM
             , t."$6"::TEXT              MID_NM
             , t."$7"::TEXT              SUFF
             , t."$8"::TEXT              GNDR
             , t."$9"::TEXT              CRED
             , t."$10"::TEXT             MED_SCH
             , t."$11"::NUMBER           GRD_YR
             , t."$12"::TEXT             PRI_SPEC
             , t."$13"::TEXT             SEC_SPEC_1
             , t."$14"::TEXT             SEC_SPEC_2
             , t."$15"::TEXT             SEC_SPEC_3
             , t."$16"::TEXT             SEC_SPEC_4
             , t."$17"::TEXT             SEC_SPEC_ALL
             , t."$18"::TEXT             ORG_NM
             , t."$19"::TEXT             ORG_PAC_ID
             , t."$20"::TEXT             NUM_ORG_MEM
             , t."$21"::TEXT             ADR_LN_1
             , t."$22"::TEXT             ADR_LN_2
             , t."$23"::TEXT             LN_2_SPRS
             , t."$24"::TEXT             CTY
             , t."$25"::TEXT             ST
             , t."$26"::TEXT             ZIP
             , t."$27"::TEXT             PHN_NUMBR
             , t."$28"::TEXT             HOSP_AFL_1
             , t."$29"::TEXT             HOSP_AFL_LBN_1
             , t."$30"::TEXT             HOSP_AFL_2
             , t."$31"::TEXT             HOSP_AFL_LBN_2
             , t."$32"::TEXT             HOSP_AFL_3
             , t."$33"::TEXT             HOSP_AFL_LBN_3
             , t."$34"::TEXT             HOSP_AFL_4
             , t."$35"::TEXT             HOSP_AFL_LBN_4
             , t."$36"::TEXT             HOSP_AFL_5
             , t."$37"::TEXT             HOSP_AFL_LBN_5
             , t."$38"::TEXT             IND_ASSGN
             , t."$39"::TEXT             GRP_ASSGN
             , t."$40"::TEXT             ADRS_ID
             , metadata$filename
             , metadata$file_row_number
             , try_to_date(regexp_substr(metadata$filename, 'stage/cms/provider/(\\d{4}/\\d{2}/\\d{2})', 1, 1, 'e', 1),
                           'YYYY/MM/DD') file_date
        from @stage.CMS_PROVIDER_STG t
    )
    file_format = (
        TYPE = CSV
            RECORD_DELIMITER = '\n'
            FIELD_DELIMITER = ','
            SKIP_HEADER = 1
            FIELD_OPTIONALLY_ENCLOSED_BY = '"'
            ENCODING = 'UTF8'
            COMPRESSION = 'GZIP'
        )
    pattern = 'stage/cms/provider/.*.csv.gz'
    on_error = continue;

-- Load the data
insert into STAGE.COPY_STATISTICS(TABLE_NAME, QUERY_ID, RESULT)
select 'CMS_PROVIDER'
     , last_query_id()
     , object_construct(*)
from table (result_scan(last_query_id()));