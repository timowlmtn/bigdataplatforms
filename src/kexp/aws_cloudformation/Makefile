# Deploys the Lambda functions and API Gateway
deploy:
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
    		ExportStage="stage/kexp" \
    		LayerAws="${LAYER_AWS}" \
    		LayerLake="${LAYER_LAKE}" \
	    --capabilities CAPABILITY_NAMED_IAM

clean:
	aws cloudformation --profile ${AWS_PROFILE} delete-stack --stack-name ${API_NAME}-${COLOR}