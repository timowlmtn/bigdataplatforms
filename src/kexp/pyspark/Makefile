default: extract-kexp-api transform-raw-bronze transform-bronze-silver

extract-kexp-api:
	python3 ./kexp_sync_api_to_raw.py

transform-raw-bronze:
	python3 ./kexp_transform_raw_to_bronze.py

list-bronze:
	ls -l ${DELTA_LAKE_FOLDER}/kexp/bronze

transform-bronze-silver:
	python3 kexp_transform_bronze_to_silver.py

sync-s3:
	aws s3 sync ${DELTA_LAKE_FOLDER}/kexp s3://${ExportBucket}/stage/kexp/delta/ # --dryrun

generate-ddl:
	python3 create_snowflake_external_tables.py
