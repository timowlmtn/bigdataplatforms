default: download-data

lint:
	black python/download_bike_data.py

download-data:
	python python/download_bike_data.py

requirements:
	pip3 install -r requirements.txt

venv:
	python -m venv h3

get-chromedriver:
	brew install chromedriver
