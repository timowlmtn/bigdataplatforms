# Import Private definitions
source ../../setenv.sh

export STACK_NAME=snowflake-storage-integration
export S3_DEPLOYMENT_BUCKET=${S3_DEPLOYMENT_BUCKET}
export SNOWFLAKE_BUCKET=customer-acme-data-lake
export SNOWFLAKE_ROLE_NAME=role-${SNOWFLAKE_BUCKET}



export SNOWFLAKE_USER="tf-snow"
export SNOWFLAKE_PRIVATE_KEY_PATH="~/.snowsql/snowflake_tf_snow_key.p8"

export SNOWFLAKE_REGION="AWS_EU_WEST_1"

export SNOWFLAKE_INTEGRATION_ROLE=${SNOWFLAKE_INTEGRATION_ROLE}

export CONNECTION=${DATABASE}
export DATABASE=${DATABASE}

export STAGE_SCHEMA=STAGE
export STAGE_ENDPOINT=SIMPLE_STAGE
export STAGE_TABLE=SIMPLE_TABLE

export CUSTOMER_VPC_ROLE_NAME=customer-acme-vpc-role

# The Snowflake Account ARN is unique to your Snowflake account
export STORAGE_AWS_IAM_USER_ARN=${SNOWFLAKE_ACCOUNT_ARN}

# The trusted condition is unique to each created Storage Integration
# Example: MyAccount_SFCRole=StorageIntegrationCode=
export STORAGE_AWS_EXTERNAL_ID=MyAccount_SFCRole=StorageIntegrationCode=

export S3_STORAGE_INTEGRATION=storage_integration_acme_customer
export S3_TF_STORAGE_INTEGRATION=storage_integration_terraform_customer

export DATABASE_ADMIN_ROLE=${DATABASE_ADMIN_ROLE}

export TF_PUBLIC_KEY=$(awk 'NR>1{a[++k]=$0}END{for(i=1;i<k;i++)printf "%s",a[i]}' snowflake_tf_snow_key.pub)

export TF_PASSWORD=$(awk 'NR>1{a[++k]=$0}END{for(i=1;i<k;i++)printf "%s",a[i]}' ~/.snowsql/snowflake_tf_snow_key.p8)
export TF_USER=tf-snow
