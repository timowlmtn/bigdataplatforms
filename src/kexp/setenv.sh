export PYTHONPATH=aws_layers

# Here is where I set my private S3 Bucket and stage locations
source ../../../setenv.sh
export ExportBucket=$EXPORT_BUCKET
export ExportStage=stage/kexp