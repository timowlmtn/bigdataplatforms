# Import Private definitions
source ../../setenv.sh

export STACK_NAME=vpc-endpoints
export S3_DEPLOYMENT_BUCKET=${S3_DEPLOYMENT_BUCKET}
export EXPORT_BUCKET=${EXPORT_BUCKET}
export SNOWFLAKE_ROLE_NAME=role-${EXPORT_BUCKET}
export EXPORT_STAGE=bigdata_example
export CONNECTION=${DATABASE}
export DATABASE=${DATABASE}

export STAGE_SCHEMA=STAGE
export STAGE_ENDPOINT=SIMPLE_STAGE

export CUSTOMER_VPC_ROLE_NAME=customer-acme-vpc-role

# The Snowflake Account ARN is unique to your Snowflake account
export TRUSTED_ENTITY=${SNOWFLAKE_ACCOUNT_ARN}

# The trusted condition is unique to each created Storage Integration
# Example: MyAccount_SFCRole=StorageIntegrationCode=
export TRUSTED_CONDITION=MyAccount_SFCRole=StorageIntegrationCode=

export S3_STORAGE_INTEGRATION=storage_integration_acme_customer

export DATABASE_ADMIN_ROLE=${DATABASE_ADMIN_ROLE}