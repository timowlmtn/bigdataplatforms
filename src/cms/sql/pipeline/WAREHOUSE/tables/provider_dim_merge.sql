merge into WAREHOUSE.PROVIDER_DIM tar
    using (
        with tip as (
            select ID, MAX(DW_MODIFIED_DATE) last_modified
            from WAREHOUSE.PROVIDER_DIM
            where SCD_IS_ACTIVE = TRUE
            group by ID)
        SELECT stg.ID
             , stg.NPI
             , stg.SOURCE
             , stg.IND_PAC_ID
             , stg.IND_ENRL_ID
             , stg.LST_NM
             , stg.FRST_NM
             , stg.MID_NM
             , stg.SUFF
             , stg.GNDR
             , stg.CRED
             , stg.MED_SCH
             , stg.GRD_YR
             , stg.PRI_SPEC
             , stg.SEC_SPEC_1
             , stg.SEC_SPEC_2
             , stg.SEC_SPEC_3
             , stg.SEC_SPEC_4
             , stg.SEC_SPEC_ALL
             , stg.ORG_NM
             , stg.ORG_PAC_ID
             , stg.NUM_ORG_MEM
             , stg.ADR_LN_1
             , stg.ADR_LN_2
             , stg.LN_2_SPRS
             , stg.CTY
             , stg.ST
             , stg.ZIP
             , stg.PHN_NUMBR
             , stg.HOSP_AFL_1
             , stg.HOSP_AFL_LBN_1
             , stg.HOSP_AFL_2
             , stg.HOSP_AFL_LBN_2
             , stg.HOSP_AFL_3
             , stg.HOSP_AFL_LBN_3
             , stg.HOSP_AFL_4
             , stg.HOSP_AFL_LBN_4
             , stg.HOSP_AFL_5
             , stg.HOSP_AFL_LBN_5
             , stg.IND_ASSGN
             , stg.GRP_ASSGN
             , stg.ADRS_ID
             , stg.STAGE_FILENAME
             , stg.STAGE_FILE_ROW_NUMBER
             , stg.STAGE_FILE_DATE
             , hash(stg.ID
            , stg.NPI
            , stg.SOURCE
            , stg.IND_PAC_ID
            , stg.IND_ENRL_ID
            , stg.LST_NM
            , stg.FRST_NM
            , stg.MID_NM
            , stg.SUFF
            , stg.GNDR
            , stg.CRED
            , stg.MED_SCH
            , stg.GRD_YR
            , stg.PRI_SPEC
            , stg.SEC_SPEC_1
            , stg.SEC_SPEC_2
            , stg.SEC_SPEC_3
            , stg.SEC_SPEC_4
            , stg.SEC_SPEC_ALL
            , stg.ORG_NM
            , stg.ORG_PAC_ID
            , stg.NUM_ORG_MEM
            , stg.ADR_LN_1
            , stg.ADR_LN_2
            , stg.LN_2_SPRS
            , stg.CTY
            , stg.ST
            , stg.ZIP
            , stg.PHN_NUMBR
            , stg.HOSP_AFL_1
            , stg.HOSP_AFL_LBN_1
            , stg.HOSP_AFL_2
            , stg.HOSP_AFL_LBN_2
            , stg.HOSP_AFL_3
            , stg.HOSP_AFL_LBN_3
            , stg.HOSP_AFL_4
            , stg.HOSP_AFL_LBN_4
            , stg.HOSP_AFL_5
            , stg.HOSP_AFL_LBN_5
            , stg.IND_ASSGN
            , stg.GRP_ASSGN
            , stg.ADRS_ID)                                                                 SCD_HASH_ID
             , row_number() over ( partition by stg.ID order by stg.STAGE_FILE_DATE desc ) row_number
        FROM STAGE.CMS_PROVIDER stg
                 left outer join tip on tip.ID = stg.ID
        where stg.DW_MODIFIED_DATE > coalesce(tip.last_modified, '1900-01-01')
          and DW_IS_ACTIVE
            qualify row_number = 1
    ) as src on src.ID = tar.ID and src.SCD_HASH_ID = tar.SCD_HASH_ID and tar.SCD_IS_ACTIVE = True
    when matched then update set
        tar.ID = src.ID
        , tar.NPI = src.NPI
        , tar.SOURCE = src.SOURCE
        , tar.IND_PAC_ID = src.IND_PAC_ID
        , tar.IND_ENRL_ID = src.IND_ENRL_ID
        , tar.LST_NM = src.LST_NM
        , tar.FRST_NM = src.FRST_NM
        , tar.MID_NM = src.MID_NM
        , tar.SUFF = src.SUFF
        , tar.GNDR = src.GNDR
        , tar.CRED = src.CRED
        , tar.MED_SCH = src.MED_SCH
        , tar.GRD_YR = src.GRD_YR
        , tar.PRI_SPEC = src.PRI_SPEC
        , tar.SEC_SPEC_1 = src.SEC_SPEC_1
        , tar.SEC_SPEC_2 = src.SEC_SPEC_2
        , tar.SEC_SPEC_3 = src.SEC_SPEC_3
        , tar.SEC_SPEC_4 = src.SEC_SPEC_4
        , tar.SEC_SPEC_ALL = src.SEC_SPEC_ALL
        , tar.ORG_NM = src.ORG_NM
        , tar.ORG_PAC_ID = src.ORG_PAC_ID
        , tar.NUM_ORG_MEM = src.NUM_ORG_MEM
        , tar.ADR_LN_1 = src.ADR_LN_1
        , tar.ADR_LN_2 = src.ADR_LN_2
        , tar.LN_2_SPRS = src.LN_2_SPRS
        , tar.CTY = src.CTY
        , tar.ST = src.ST
        , tar.ZIP = src.ZIP
        , tar.PHN_NUMBR = src.PHN_NUMBR
        , tar.HOSP_AFL_1 = src.HOSP_AFL_1
        , tar.HOSP_AFL_LBN_1 = src.HOSP_AFL_LBN_1
        , tar.HOSP_AFL_2 = src.HOSP_AFL_2
        , tar.HOSP_AFL_LBN_2 = src.HOSP_AFL_LBN_2
        , tar.HOSP_AFL_3 = src.HOSP_AFL_3
        , tar.HOSP_AFL_LBN_3 = src.HOSP_AFL_LBN_3
        , tar.HOSP_AFL_4 = src.HOSP_AFL_4
        , tar.HOSP_AFL_LBN_4 = src.HOSP_AFL_LBN_4
        , tar.HOSP_AFL_5 = src.HOSP_AFL_5
        , tar.HOSP_AFL_LBN_5 = src.HOSP_AFL_LBN_5
        , tar.IND_ASSGN = src.IND_ASSGN
        , tar.GRP_ASSGN = src.GRP_ASSGN
        , tar.ADRS_ID = src.ADRS_ID
        , tar.STAGE_FILENAME = src.STAGE_FILENAME
        , tar.STAGE_FILE_ROW_NUMBER = src.STAGE_FILE_ROW_NUMBER
        , tar.STAGE_FILE_DATE = src.STAGE_FILE_DATE
    when not matched then insert (ID, NPI, SOURCE, IND_PAC_ID, IND_ENRL_ID, LST_NM, FRST_NM, MID_NM, SUFF, GNDR, CRED,
                                  MED_SCH, GRD_YR, PRI_SPEC, SEC_SPEC_1, SEC_SPEC_2, SEC_SPEC_3, SEC_SPEC_4,
                                  SEC_SPEC_ALL, ORG_NM, ORG_PAC_ID, NUM_ORG_MEM, ADR_LN_1, ADR_LN_2, LN_2_SPRS, CTY, ST,
                                  ZIP, PHN_NUMBR, HOSP_AFL_1, HOSP_AFL_LBN_1, HOSP_AFL_2, HOSP_AFL_LBN_2, HOSP_AFL_3,
                                  HOSP_AFL_LBN_3, HOSP_AFL_4, HOSP_AFL_LBN_4, HOSP_AFL_5, HOSP_AFL_LBN_5, IND_ASSGN,
                                  GRP_ASSGN, ADRS_ID, STAGE_FILENAME, STAGE_FILE_ROW_NUMBER, STAGE_FILE_DATE,
                                  SCD_IS_ACTIVE, SCD_HASH_ID) values ( src.ID
                                                                     , src.NPI
                                                                     , src.SOURCE
                                                                     , src.IND_PAC_ID
                                                                     , src.IND_ENRL_ID
                                                                     , src.LST_NM
                                                                     , src.FRST_NM
                                                                     , src.MID_NM
                                                                     , src.SUFF
                                                                     , src.GNDR
                                                                     , src.CRED
                                                                     , src.MED_SCH
                                                                     , src.GRD_YR
                                                                     , src.PRI_SPEC
                                                                     , src.SEC_SPEC_1
                                                                     , src.SEC_SPEC_2
                                                                     , src.SEC_SPEC_3
                                                                     , src.SEC_SPEC_4
                                                                     , src.SEC_SPEC_ALL
                                                                     , src.ORG_NM
                                                                     , src.ORG_PAC_ID
                                                                     , src.NUM_ORG_MEM
                                                                     , src.ADR_LN_1
                                                                     , src.ADR_LN_2
                                                                     , src.LN_2_SPRS
                                                                     , src.CTY
                                                                     , src.ST
                                                                     , src.ZIP
                                                                     , src.PHN_NUMBR
                                                                     , src.HOSP_AFL_1
                                                                     , src.HOSP_AFL_LBN_1
                                                                     , src.HOSP_AFL_2
                                                                     , src.HOSP_AFL_LBN_2
                                                                     , src.HOSP_AFL_3
                                                                     , src.HOSP_AFL_LBN_3
                                                                     , src.HOSP_AFL_4
                                                                     , src.HOSP_AFL_LBN_4
                                                                     , src.HOSP_AFL_5
                                                                     , src.HOSP_AFL_LBN_5
                                                                     , src.IND_ASSGN
                                                                     , src.GRP_ASSGN
                                                                     , src.ADRS_ID
                                                                     , src.STAGE_FILENAME
                                                                     , src.STAGE_FILE_ROW_NUMBER
                                                                     , src.STAGE_FILE_DATE, false, hash(src.ID
                                                                           , src.NPI
                                                                           , src.SOURCE
                                                                           , src.IND_PAC_ID
                                                                           , src.IND_ENRL_ID
                                                                           , src.LST_NM
                                                                           , src.FRST_NM
                                                                           , src.MID_NM
                                                                           , src.SUFF
                                                                           , src.GNDR
                                                                           , src.CRED
                                                                           , src.MED_SCH
                                                                           , src.GRD_YR
                                                                           , src.PRI_SPEC
                                                                           , src.SEC_SPEC_1
                                                                           , src.SEC_SPEC_2
                                                                           , src.SEC_SPEC_3
                                                                           , src.SEC_SPEC_4
                                                                           , src.SEC_SPEC_ALL
                                                                           , src.ORG_NM
                                                                           , src.ORG_PAC_ID
                                                                           , src.NUM_ORG_MEM
                                                                           , src.ADR_LN_1
                                                                           , src.ADR_LN_2
                                                                           , src.LN_2_SPRS
                                                                           , src.CTY
                                                                           , src.ST
                                                                           , src.ZIP
                                                                           , src.PHN_NUMBR
                                                                           , src.HOSP_AFL_1
                                                                           , src.HOSP_AFL_LBN_1
                                                                           , src.HOSP_AFL_2
                                                                           , src.HOSP_AFL_LBN_2
                                                                           , src.HOSP_AFL_3
                                                                           , src.HOSP_AFL_LBN_3
                                                                           , src.HOSP_AFL_4
                                                                           , src.HOSP_AFL_LBN_4
                                                                           , src.HOSP_AFL_5
                                                                           , src.HOSP_AFL_LBN_5
                                                                           , src.IND_ASSGN
                                                                           , src.GRP_ASSGN
                                                                           , src.ADRS_ID));