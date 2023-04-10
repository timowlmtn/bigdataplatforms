default: deploy-lakelayer-all

# This script uses remote calls to an EC2 host.
# Create the EC2 host and then shut it off.
#
# 	export EC2_HOST=ubuntu@ec2-3-235-241-45.compute-1.amazonaws.com
#
deploy-lakelayer-all: deploy-lakelayer deploy-aws-layer-version

deploy-lakelayer-clean:
	ssh -i ${PEM_FILE} ${EC2_HOST} "rm -rf lakelayer"

deploy-lakelayer-mkdir:
	ssh -i ${PEM_FILE} ${EC2_HOST} "mkdir -p lakelayer/python/lib/python3.7/site-packages/lakelayer"

deploy-lakelayer-scp:
	scp -ri ${PEM_FILE} lakelayer ${EC2_HOST}:lakelayer/python/lib/python3.7/site-packages

deploy-lakelayer-requests:
	ssh -i ${PEM_FILE} ${EC2_HOST} "/home/ubuntu/.pyenv/versions/3.7.2/bin/pip3 install requests -t lakelayer/python/lib/python3.7/site-packages"

deploy-lakelayer-pytz:
	ssh -i ${PEM_FILE} ${EC2_HOST} "/home/ubuntu/.pyenv/versions/3.7.2/bin/pip3 install pytz -t lakelayer/python/lib/python3.7/site-packages"

deploy-lakelayer-compile:
	ssh -i ${PEM_FILE} ${EC2_HOST} "rm -rf lakelayer/python/lib/python3.7/site-packages/lakelayer/__pycache__"
	ssh -i ${PEM_FILE} ${EC2_HOST} "python3 -m compileall lakelayer/python/lib/python3.7/site-packages/lakelayer/"

deploy-lakelayer-zip:
	ssh -i ${PEM_FILE} ${EC2_HOST} "cd lakelayer; zip -r lakelayer.zip ."

deploy-lakelayer-cp:
	ssh -i ${PEM_FILE} ${EC2_HOST} "aws s3 cp lakelayer/lakelayer.zip s3://${S3_DEPLOYMENT_BUCKET}/layer/"

deploy-lakelayer: deploy-lakelayer-clean deploy-lakelayer-mkdir deploy-lakelayer-mkdir \
    deploy-lakelayer-pytz deploy-lakelayer-requests \
	deploy-lakelayer-scp deploy-lakelayer-compile deploy-lakelayer-zip \
	deploy-lakelayer-cp


deploy-aws-layer-version:
	aws --profile ${AWS_PROFILE} lambda publish-layer-version \
	--layer-name lakelayer \
	--description "Lambda Layer containing data source libraries" \
	--content S3Bucket=${S3_DEPLOYMENT_BUCKET},S3Key=layer/lakelayer.zip \
	--compatible-runtimes python3.6 python3.7
