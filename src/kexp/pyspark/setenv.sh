export PYTHONPATH=../aws_layers:.

# Here is where I set my private S3 Bucket and stage locations
source ../../../../setenv.sh

export RAW_DATA_FOLDER=../data/export
export DELTA_LAKE_FOLDER=../../../data/spark/kexp

# Here is where I set my private S3 Bucket and stage locations
export ExportBucket=$EXPORT_BUCKET

# Here I set the root location to for all KEXP Stages in Snowflake
export ExportStage=stage/raw/kexp