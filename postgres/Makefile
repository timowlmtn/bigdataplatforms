default: run-postgres

run-postgres:
	docker run --name postgres_container \
	  -e POSTGRES_USER=${PG_USER} \
	  -e POSTGRES_PASSWORD=${PG_PASSWORD} \
	  -e POSTGRES_DB=mlops \
	  -p 5432:5432 \
	  -v pgdata:/var/lib/postgresql/data \
	  -d postgres

validate:
	docker ps | grep postgres

shell:
	docker exec -it postgres_container psql -U ${PG_USER} -d mlops