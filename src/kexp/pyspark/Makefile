default: transform-raw-bronze

analyze-bronze:
	python3 kexp_analyze.py

transform-raw-bronze:
	python3 ./kexp_transform_raw_to_bronze.py

transform-bronze-silver:
	python3 kexp_transform_bronze_silver.py

upgrade-pyspark:
	pip install pyspark --upgrade

upgrade-delta:
	pip install delta-spark --upgrade

upgrade: upgrade-pyspark upgrade-delta

version:
	pyspark --version
