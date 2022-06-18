clean-s3:
	aws s3 rm  s3://${EXPORT_BUCKET}/stage/hl7 --recursive --dryrun

sync-s3:
	aws s3 sync ${DATA_HOME} s3://${EXPORT_BUCKET}/stage/hl7 --exclude="*" \
		--include="*" # --dryrun
