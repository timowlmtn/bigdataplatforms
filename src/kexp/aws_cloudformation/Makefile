# Deploys the Lambda functions and API Gateway
deploy-pipeline:
	aws cloudformation --profile ${AWS_PROFILE} package \
		--template-file kexp_cloudformation.yml \
	    --s3-bucket ${S3_DEPLOYMENT_BUCKET} \
	    --output-template-file build/packaged-kexp_cloudformation.yaml
	aws cloudformation --profile ${AWS_PROFILE} deploy \
		--template-file build/packaged-kexp_cloudformation.yaml \
	    --stack-name ${API_NAME}-${COLOR} \
	    --parameter-overrides \
    		RestApiName=${API_NAME}-Rest-${COLOR} Environment=${ENVIRONMENT} \
    		ExportBucket="${EXPORT_BUCKET}" ExportBucketArn="${EXPORT_BUCKET_ARN}" \
    		ExportStage=${EXPORT_STAGE} \
    		LayerAws="${LAYER_AWS}" \
    		LayerLake="${LAYER_LAKE}" \
	    --capabilities CAPABILITY_NAMED_IAM

deploy-stage-role:
	aws cloudformation --profile ${AWS_PROFILE} package \
		--template-file snowflake_integration_role.yml \
	    --s3-bucket ${S3_DEPLOYMENT_BUCKET} \
	    --output-template-file build/snowflake_integration_role.yml
	aws cloudformation --profile ${AWS_PROFILE} deploy \
		--template-file build/snowflake_integration_role.yml \
	    --stack-name ${STAGE_NAME}-${COLOR} \
	    --parameter-overrides \
    		StageLocationArn="${STAGE_LOCATION_ARN}" ExportBucketArn="${EXPORT_BUCKET_ARN}" \
    		SnowflakePrincipalArn="${TRUSTED_ENTITY}" \
    		SnowflakeExternalId="${TRUSTED_CONDITION}" \
	    --capabilities CAPABILITY_NAMED_IAM


deploy-stage-bucket:
	aws cloudformation --profile ${AWS_PROFILE} package \
		--template-file aws_stage_bucket.yml \
	    --s3-bucket ${S3_DEPLOYMENT_BUCKET} \
	    --output-template-file build/aws_stage_bucket.yml
	aws cloudformation --profile ${AWS_PROFILE} deploy \
		--template-file build/aws_stage_bucket.yml \
	    --stack-name ${STAGE_NAME}-${COLOR} \
	    --parameter-overrides \
    		ExportBucket="${EXPORT_BUCKET}" ExportBucketArn="${EXPORT_BUCKET_ARN}" \
    		ExportStage=${EXPORT_STAGE} \
	    --capabilities CAPABILITY_NAMED_IAM

deploy: deploy-pipeline

clean: clean-pipeline clean-stage

clean-pipeline:
	aws cloudformation --profile ${AWS_PROFILE} delete-stack --stack-name ${API_NAME}-${COLOR}

clean-stage:
	aws cloudformation --profile ${AWS_PROFILE} delete-stack --stack-name ${STAGE_NAME}-${COLOR}