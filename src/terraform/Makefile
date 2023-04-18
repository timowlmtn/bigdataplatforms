apply-snowflake:
	terraform -chdir=layers/snowflake apply -var="prefix=owlmtn"

plan-snowflake:
	terraform -chdir=layers/snowflake plan -var="prefix=owlmtn"

init-snowflake:
	terraform -chdir=layers/snowflake init

apply-databricks:
	terraform -chdir=layers/databricks apply -auto-approve -var-file="../../environments/owlmtn.tfvars"

plan-databricks:
	terraform -chdir=layers/databricks plan -var-file="../../environments/owlmtn.tfvars"

# Initialize a working directory containing the terraform config files
init-databricks:
	terraform -chdir=layers/databricks init

install:
	brew install hashicorp/tap/terraform