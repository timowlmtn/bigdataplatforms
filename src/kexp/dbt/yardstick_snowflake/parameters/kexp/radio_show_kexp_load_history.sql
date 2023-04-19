copy into LANDING_ZONE.RADIO_SHOW_KEXP(
            id,
            host_names,
            host_uris,
            hosts,
            image_uri,
            program,
            program_name,
            program_tags,
            program_uri,
            start_time,
            tagline,
            uri,
            LANDING_ZONE_SOURCE,
            LANDING_ZONE_CREATED_TIMESTAMP,
            LANDING_ZONE_MODIFIED_TIMESTAMP,
            LANDING_ZONE_HIDDEN,
            LANDING_ZONE_FILENAME,
            LANDING_ZONE_FILE_ROW_NUMBER
        )
    from (
        select
            $1:id::NUMBER id,
            $1:host_names::VARIANT host_names,
            $1:host_uris::VARIANT host_uris,
            $1:hosts::VARIANT hosts,
            $1:image_uri::TEXT image_uri,
            $1:program::NUMBER program,
            $1:program_name::TEXT program_name,
            $1:program_tags::TEXT program_tags,
            $1:program_uri::TEXT program_uri,
            $1:start_time::TIMESTAMP start_time,
            $1:tagline::TEXT tagline,
            $1:uri::TEXT uri,
            'kexp' LANDING_ZONE_SOURCE,
            current_timestamp() LANDING_ZONE_CREATED_TIMESTAMP,
            current_timestamp() LANDING_ZONE_MODIFIED_TIMESTAMP,
            FALSE LANDING_ZONE_HIDDEN,
            metadata$filename LANDING_ZONE_FILENAME,
            metadata$file_row_number LANDING_ZONE_FILE_ROW_NUMBER
        from @LANDING_ZONE.RADIO_STAGE_KEXP
    )
    file_format = (
     type = 'JSON'
   )
;