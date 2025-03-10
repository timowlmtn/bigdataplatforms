run-producer:
	python python/producer.py

run-consumer:
	python python/consumer.py

kafka_env:
	python -m venv kafka

create-kafka-cluster:
	awslocal kafka create-cluster \
	  --cluster-name my-kafka-cluster \
	  --broker-node-group-info file://broker-config.json \
	  --kafka-version 2.8.1 \
	  --number-of-broker-nodes 1

install-requirements:
	pip install -r requirements.txt

list-topics:
	docker exec -it kafka kafka-topics.sh --bootstrap-server localhost:9092 --list

create-topic:
	docker exec -it kafka kafka-topics.sh --create --topic hello-world --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1


start-docker:
	docker-compose up -d

install-localstack:
	docker pull localstack/localstack
