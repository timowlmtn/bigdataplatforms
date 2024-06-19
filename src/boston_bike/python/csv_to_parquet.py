import shutil
from pyspark import SparkContext
from pyspark.sql import SQLContext

def spark_csv_to_parquet(input_file, output_folder):
    sc = SparkContext(appName="CSV2Parquet")
    sqlContext = SQLContext(sc)

    # try:
    #     shutil.rmtree(output_folder)
    # except OSError as e:
    #     print("Warning: %s : %s" % (output_folder, e.strerror))
    #
    # df = sqlContext.read.csv(input_file,
    #                          inferSchema=True,
    #                          header=True,
    #                          sep=",")
    #
    # df.write.parquet(output_folder)


spark_csv_to_parquet('data/202405-bluebikes-tripdata_head.csv', 'data/bluebikes-tripdata')