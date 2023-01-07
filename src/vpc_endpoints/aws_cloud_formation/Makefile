deploy-role:
	aws cloudformation --profile ${AWS_PROFILE} package \
		--template-file snowflake_vpc_role.yml \
	    --s3-bucket ${S3_DEPLOYMENT_BUCKET} \
	    --output-template-file build/snowflake_vpc_role.yml
	aws cloudformation --profile ${AWS_PROFILE} deploy \
		--template-file build/snowflake_vpc_role.yml \
	    --stack-name ${STACK_NAME}-role \
	    --parameter-overrides \
    		StageBucketArn="arn:aws:s3:::${EXPORT_BUCKET}" \
    		ExportBucketArn="arn:aws:s3:::${EXPORT_BUCKET}" \
    		SnowflakePrincipalArn="${TRUSTED_ENTITY}" \
    		SnowflakeExternalId="${TRUSTED_CONDITION}" \
	    --capabilities CAPABILITY_NAMED_IAM

clean-role:
	aws cloudformation --profile ${AWS_PROFILE} delete-stack --stack-name ${STACK_NAME}-role

deploy-bucket:
	aws cloudformation --profile ${AWS_PROFILE} package \
		--template-file aws_stage_bucket.yml \
	    --s3-bucket ${S3_DEPLOYMENT_BUCKET} \
	    --output-template-file build/aws_stage_bucket.yml
	aws cloudformation --profile ${AWS_PROFILE} deploy \
		--template-file build/aws_stage_bucket.yml \
	    --stack-name ${STACK_NAME}-bucket \
	    --parameter-overrides \
    		ExportBucket="${EXPORT_BUCKET}" ExportBucketArn="arn:aws:s3:::${EXPORT_BUCKET}" \
    		ExportStage=${EXPORT_STAGE} \
	    --capabilities CAPABILITY_NAMED_IAM

clean-bucket:
	aws cloudformation --profile ${AWS_PROFILE} delete-stack --stack-name ${STACK_NAME}-BUCKET

