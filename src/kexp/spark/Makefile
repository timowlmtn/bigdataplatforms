analyze-bronze:
	python3 kexp_analyze.py

process-row-bronze:
	python3 kexp_process_raw_to_bronze.py

upgrade-pyspark:
	pip install pyspark --upgrade

upgrade-delta:
	pip install delta-spark --upgrade

upgrade: upgrade-pyspark upgrade-delta

version:
	pyspark --version
