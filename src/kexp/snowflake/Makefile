create-kexp-stage:
	snowsql -D STORAGE_INTEGRATION_NAME=${S3_STORAGE_INTEGRATION} \
	 		-D EXPORT_BUCKET=${EXPORT_BUCKET} \
	 		-D SNOWFLAKE_INTEGRATION_ROLE=${SNOWFLAKE_INTEGRATION_ROLE} \
	 		-D DATABASE=${DATABASE} \
	 		-D DATABASE_ADMIN_ROLE=${DATABASE_ADMIN_ROLE} \
	 		-f ddl/create_stage.sql

create-kexp-program-stage:
	snowsql -D STORAGE_INTEGRATION_NAME=${STORAGE_INTEGRATION} \
			-D EXPORT_BUCKET=${EXPORT_BUCKET} \
			-D DATABASE_ADMIN_ROLE=${DATABASE_ADMIN_ROLE} \
	 		-f snowflake/ddl/STAGE/stages/stage_kexp_program_create.sql

create-load-id-sequence:
	snowsql -D DATABASE_ADMIN_ROLE=${DATABASE_ADMIN_ROLE} \
	 		-f snowflake/ddl/STAGE/sequences/load_id_sequence_create.sql

create-kexp-program-import: create-load-id-sequence
	snowsql -D DATABASE_ADMIN_ROLE=${DATABASE_ADMIN_ROLE} \
	 		-f snowflake/ddl/STAGE/tables/import_kexp_program_create.sql

create-storage-integration:
	snowsql -D STORAGE_INTEGRATION_NAME=${S3_STORAGE_INTEGRATION} \
	 		-D EXPORT_BUCKET=${EXPORT_BUCKET} \
	 		-D SNOWFLAKE_INTEGRATION_ROLE=${SNOWFLAKE_INTEGRATION_ROLE} \
	 		-D DATABASE=${DATABASE} \
	 		-D DATABASE_ADMIN_ROLE=${DATABASE_ADMIN_ROLE} \
	 		-f ddl/create_storage_integration.sql