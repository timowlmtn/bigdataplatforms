default: extract-kexp-api

extract-kexp-api:
	python3 ./kexp_sync_api_to_raw.py

extract-kexp: extract-kexp-api
	 aws s3 ls s3://${ExportBucket}/${ExportStage}/programs/
	 aws s3 cp s3://${ExportBucket}/${ExportStage}/programs/20230403032951/programs_20230403032951_1_36.jsonl -

transform-raw-bronze:
	python3 ./kexp_transform_raw_to_bronze.py

list-bronze:
	ls -l ${DELTA_LAKE_FOLDER}/kexp/bronze
transform-bronze-silver:
	python3 kexp_transform_bronze_silver.py

install-pyspark:
	pip install pyspark --upgrade

install-delta:
	pip install delta-spark --upgrade

install-hadoop:
	brew install hadoop

upgrade: upgrade-pyspark upgrade-delta

version:
	pyspark --version
