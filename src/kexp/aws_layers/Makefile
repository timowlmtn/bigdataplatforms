default: deploy-lakelayer

# This script uses remote calls to an EC2 host.
# Create the EC2 host and then shut it off.
#
# 	export EC2_HOST=ubuntu@ec2-3-235-241-45.compute-1.amazonaws.com
#
deploy-lakelayer: deploy-zip-lakelayer deploy-lambda-layer-lakelayer


deploy-zip-lakelayer-clean:
	ssh -i ${PEM_FILE} ${EC2_HOST} "rm -rf lakelayer"

deploy-zip-lakelayer-mkdir:
	ssh -i ${PEM_FILE} ${EC2_HOST} "mkdir -p lakelayer/python/lib/python3.7/site-packages/lakelayer"

deploy-zip-lakelayer-scp:
	scp -ri ${PEM_FILE} lakelayer ${EC2_HOST}:lakelayer/python/lib/python3.7/site-packages

deploy-zip-lakelayer-compile:
	ssh -i ${PEM_FILE} ${EC2_HOST} "rm -rf lakelayer/python/lib/python3.7/site-packages/lakelayer/__pycache__"
	ssh -i ${PEM_FILE} ${EC2_HOST} "python3 -m compileall lakelayer/python/lib/python3.7/site-packages/lakelayer/"

deploy-zip-lakelayer-zip:
	ssh -i ${PEM_FILE} ${EC2_HOST} "cd lakelayer; zip -r lakelayer.zip ."

deploy-zip-lakelayer-cp:
	ssh -i ${PEM_FILE} ${EC2_HOST} "aws s3 cp lakelayer/lakelayer.zip s3://${S3_DEPLOYMENT_BUCKET}/layer/"

deploy-zip-lakelayer: deploy-zip-lakelayer-clean deploy-zip-lakelayer-mkdir deploy-zip-lakelayer-mkdir \
	deploy-zip-lakelayer-scp deploy-zip-lakelayer-compile deploy-zip-lakelayer-zip deploy-zip-lakelayer-cp


deploy-lambda-layer-lakelayer:
	aws --profile ${AWS_PROFILE} lambda publish-layer-version \
	--layer-name lakelayer \
	--description "Lambda Layer containing data source libraries" \
	--content S3Bucket=${S3_DEPLOYMENT_BUCKET},S3Key=layer/lakelayer.zip \
	--compatible-runtimes python3.6 python3.7
