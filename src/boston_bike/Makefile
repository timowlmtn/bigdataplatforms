default: download-data

convert-parquet:
	python python/csv_to_parquet.py

lint:
	black python

download-data:
	python python/download_bike_data.py

requirements:
	pip3 install -r requirements.txt

venv:
	python -m venv h3

get-chromedriver:
	brew install chromedriver

build-docker:
	docker build -t spark-arm64 .

run-docker:
	docker run spark-arm64

ps-docker:
	docker ps --all | grep spark