clean-s3:
	aws s3 rm  s3://${EXPORT_BUCKET}/stage/hl7 --recursive --dryrun

sync-s3:
	aws s3 sync ${DATA_HOME} s3://${EXPORT_BUCKET}/stage/hl7 --exclude="*" \
		--include="*" # --dryrun

create-hl7-stage:
	snowsql -D STORAGE_INTEGRATION_NAME=${HL7_STORAGE_INTEGRATION} \
		-D EXPORT_BUCKET=${EXPORT_BUCKET}  \
		-f sql/ddl/STAGE/tables/hl7_stage_create.sql -o log_level=DEBUG