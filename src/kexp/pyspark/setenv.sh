export PYTHONPATH=../layers:.

# Here is where I set my private S3 Bucket and stage locations
source ../../../../setenv.sh

export RAW_DATA_FOLDER=../../../data/raw
export DELTA_LAKE_FOLDER=../../../data/spark

# Here is where I set my private S3 Bucket and stage locations
export ExportBucket=$EXPORT_BUCKET

# Here I set the root location to for all KEXP Stages in Snowflake
export ExportStage=stage/raw/kexp
export SNOWFLAKE_LANDING_ZONE=STAGE

export DELTA_LAKE_S3=stage/kexp/delta