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

venv:
	python -m venv mlflow
