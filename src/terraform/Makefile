apply-datalake:
	terraform -chdir=layers/datalake apply   -var="prefix=${PREFIX}" -var="environment=${ENVIRONMENT}" \
		-var="domain=${DOMAIN}" -var="aws_account_id=${AWS_ACCOUNT_ID}"  -auto-approve

plan-datalake:
	terraform -chdir=layers/datalake plan -var="prefix=${PREFIX}" -var="environment=${ENVIRONMENT}" \
		-var="domain=${DOMAIN}" -var="aws_account_id=${AWS_ACCOUNT_ID}"

init-datalake:
	terraform -chdir=layers/datalake init

output-snowflake:
	terraform -chdir=layers/snowflake output

destroy-snowflake:
	terraform -chdir=layers/snowflake destroy -var="prefix=${PREFIX}" -var="environment=${ENVIRONMENT}" \
		-var="domain=${DOMAIN}" -var="aws_account_id=${AWS_ACCOUNT_ID}" -auto-approve

apply-snowflake:
	terraform -chdir=layers/snowflake apply -var="prefix=${PREFIX}" -var="environment=${ENVIRONMENT}" \
		-var="domain=${DOMAIN}" -var="aws_account_id=${AWS_ACCOUNT_ID}" -auto-approve

plan-snowflake:
	terraform -chdir=layers/snowflake plan -var="prefix=${PREFIX}" -var="environment=${ENVIRONMENT}" \
		-var="domain=${DOMAIN}" -var="aws_account_id=${AWS_ACCOUNT_ID}"

init-snowflake:
	terraform -chdir=layers/snowflake init


init-snowflake-module:
	terraform -chdir=modules/snowflake init

apply-databricks:
	terraform -chdir=layers/databricks apply -auto-approve -var-file="../../environments/owlmtn.tfvars"

plan-databricks:
	terraform -chdir=layers/databricks plan -var-file="../../environments/owlmtn.tfvars"

# Initialize a working directory containing the terraform config files
init-databricks:
	terraform -chdir=layers/databricks init

install:
	brew install hashicorp/tap/terraform

get-session-token:
	aws --profile databricks_user sts get-session-token --duration-seconds 129600
