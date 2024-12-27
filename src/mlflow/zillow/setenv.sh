source zillow/bin/activate

export SPARK_HOME=$PWD/spark
export DBT_PROFILES_DIR=$PWD/zillow_pipeline
export DBT_PROJECT_DIR=$PWD/zillow_pipeline

export SPARK_DRIVER_EXTRA_JAVA_OPTIONS=-Djava.security.manager=allow
export SPARK_EXECUTOR_EXTRA_JAVA_OPTIONS=-Djava.security.manager=allow


export HADOOP_HOME=/opt/homebrew/opt/hadoop
export JAVA_HOME=/opt/homebrew/opt/openjdk
export HIVE_VERSION=4.0.0
