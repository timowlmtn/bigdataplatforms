client:
	clickhouse client -h localhost

run-minikube:
	minikube start

install:
	kubectl apply -f https://raw.githubusercontent.com/Altinity/clickhouse-operator/master/deploy/operator/clickhouse-operator-install-bundle.yaml


get-pods:
	kubectl get pods -n test-clickhouse-operator

get-service:
	kubectl get service -n test-clickhouse-operator

forward-ports:
	kubectl -n test-clickhouse-operator port-forward chi-simple-01-simple-0-0-0 9000:9000 &

show-head:
	aws s3 cp s3://owlmtn-datalake-prod/stage/kexp/playlists/20231225110357/playlist20231225110357.json - | head

get-env-vars:
	kubectl -n test-clickhouse-operator exec -it chi-simple-01-simple-0-0-0 -- env

custom-env-variable:
	curl -s https://raw.githubusercontent.com/Altinity/clickhouse-operator/master/deploy/operator-web-installer/clickhouse-operator-install.sh | TEST_VALUE=hello-world-tim bash