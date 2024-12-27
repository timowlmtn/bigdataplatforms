default: mlflow-iris

mlflow-iris:
	python python/mlflow_lr_iris.py

lint:
	black python

requirements:
	pip3 install -r requirements.txt

ui:
	mlflow ui

black:
	black python
	black zillow/python

mlflow_env:
	python -m venv mlflow

zillow_env:
	python -m venv zillow

get-chromedriver:
	brew install chromedriver

zillow-delta:
	python python/zillow_to_delta_lake.py

zillow-hive:
	python python/zillow_to_hive.py


dbt:
	dbt init zillow_pipeline --skip-profile-setup

pyspark:
	pyspark --conf spark.sql.warehouse.dir=./zillow_delta --conf spark.driver.extraJavaOptions=-Djava.security.manager=allow

spark-shell:
	spark/bin/spark-shell \
	  --conf spark.driver.extraJavaOptions=-Djava.security.manager=allow \
	  --conf spark.executor.extraJavaOptions=-Djava.security.manager=allow

hive:
	docker run -d -p 10000:10000 -p 10002:10002 --env SERVICE_NAME=hiveserver2 --name hive4 apache/hive:${HIVE_VERSION}

hive-client:
	docker exec -it hive4 beeline -u jdbc:hive2://localhost:10000

