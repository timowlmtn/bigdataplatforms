create-kafka-cluster:
	awslocal kafka create-cluster \
	  --cluster-name my-kafka-cluster \
	  --broker-node-group-info file://broker-config.json \
	  --kafka-version 2.8.1 \
	  --number-of-broker-nodes 1

install-requirements:
	pip install -r requirements.txt

start-localstack:
	docker-compose up -d

install-localstack:
	docker pull localstack/localstack
