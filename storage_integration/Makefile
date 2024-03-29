default: create-storage-integration

update-role:
	aws cloudformation --profile ${AWS_PROFILE} package \
		--template-file src/aws_cloud_formation/snowflake_vpc_role.yml \
	    --s3-bucket ${S3_DEPLOYMENT_BUCKET} \
	    --output-template-file build/snowflake_vpc_role.yml
	aws cloudformation --profile ${AWS_PROFILE} deploy \
		--template-file build/snowflake_vpc_role.yml \
	    --stack-name ${STACK_NAME}-role \
	    --parameter-overrides \
	    	SnowflakeRoleName="${SNOWFLAKE_ROLE_NAME}" \
	    	SnowflakeBucketArn="arn:aws:s3:::${SNOWFLAKE_BUCKET}" \
    		SnowflakePrincipalArn="${STORAGE_AWS_IAM_USER_ARN}" \
    		SnowflakeExternalId="${STORAGE_AWS_EXTERNAL_ID}" \
	    --capabilities CAPABILITY_NAMED_IAM

clean-role:
	aws cloudformation --profile ${AWS_PROFILE} delete-stack --stack-name ${STACK_NAME}-role


install-snowsql:
	brew install --cask snowflake-snowsql

create-bucket:
	aws cloudformation --profile ${AWS_PROFILE} package \
		--template-file src/aws_cloud_formation/aws_stage_bucket.yml \
	    --s3-bucket ${S3_DEPLOYMENT_BUCKET} \
	    --output-template-file build/aws_stage_bucket.yml
	aws cloudformation --profile ${AWS_PROFILE} deploy \
		--template-file build/aws_stage_bucket.yml \
	    --stack-name ${STACK_NAME}-bucket \
	    --parameter-overrides \
    		SnowflakeBucket="${SNOWFLAKE_BUCKET}" \
	    --capabilities CAPABILITY_NAMED_IAM

clean-bucket:
	aws cloudformation --profile ${AWS_PROFILE} delete-stack --stack-name ${STACK_NAME}-bucket

create-storage-integration:
	snowsql --connection ${CONNECTION} \
			-D STORAGE_INTEGRATION_NAME=${S3_STORAGE_INTEGRATION} \
			-D STORAGE_ALLOWED_LOCATIONS=${STORAGE_ALLOWED_LOCATIONS} \
	 		-D SNOWFLAKE_BUCKET=${SNOWFLAKE_BUCKET} \
	 		-D SNOWFLAKE_INTEGRATION_ROLE=${SNOWFLAKE_INTEGRATION_ROLE} \
	 		-D DATABASE=${DATABASE} \
	 		-D DATABASE_ADMIN_ROLE=${DATABASE_ADMIN_ROLE} \
	 		-f src/snowflake/create_storage_integration.sql

create-simple-stage:
	snowsql --connection ${CONNECTION} \
			--rolename ${DATABASE_ADMIN_ROLE} \
			-D STORAGE_INTEGRATION_NAME=${S3_STORAGE_INTEGRATION} \
	 		-D SNOWFLAKE_BUCKET=${SNOWFLAKE_BUCKET} \
	 		-D STAGE_SCHEMA=${STAGE_SCHEMA} \
	 		-D STAGE_ENDPOINT=${STAGE_ENDPOINT} \
	 		-f src/snowflake/create_simple_stage.sql


create-simple-table:
	snowsql --connection ${CONNECTION} \
			--rolename ${DATABASE_ADMIN_ROLE} \
			-D STORAGE_INTEGRATION_NAME=${S3_STORAGE_INTEGRATION} \
	 		-D STAGE_SCHEMA=${STAGE_SCHEMA} \
	 		-D STAGE_TABLE=${STAGE_TABLE} \
	 		-f src/snowflake/create_simple_table.sql

deploy-test-data:
	aws --profile ${AWS_PROFILE} s3 sync data s3://${SNOWFLAKE_BUCKET}/stage/prototype # --dryrun

# -------------------------------------- terraform

# Create Snowflake user Private key and password
tf-create-private-key:
	openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out ~/.snowsql/snowflake_tf_snow_key.p8 -nocrypt
	openssl rsa -in ~/.snowsql/snowflake_tf_snow_key.p8 -pubout -out ./snowflake_tf_snow_key.pub

# remove opening and ending brackets in key
tf-create-user:
	snowsql --connection ${CONNECTION} \
			--rolename ${DATABASE_ADMIN_ROLE} \
			-D TF_USER=${TF_USER} \
			-D TF_PASSWORD=${TF_PASSWORD} \
			-D TF_PUBLIC_KEY=${TF_PUBLIC_KEY} \
	 		-f src/snowflake/terraform_create_user.sql

tf-install:
	brew tap hashicorp/tap
	brew install hashicorp/tap/terraform

tf-init:
	terraform -chdir="./src/terraform"  init -upgrade

tf-plan:
	terraform -chdir="./src/terraform" plan -var "storage-integration-name=${S3_TF_STORAGE_INTEGRATION}"

tf-validate:
	terraform -chdir="./src/terraform" validate

tf-apply:
	terraform -chdir="./src/terraform" apply -var "storage-integration-name=${S3_TF_STORAGE_INTEGRATION}" -auto-approve

