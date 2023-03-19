from pyspark.sql import SparkSession

# using SQLContext to read parquet file
from pyspark.sql import SQLContext

if __name__ == "__main__":
    # initialise sparkContext
    spark = SparkSession.builder \
        .master('local') \
        .appName('myAppName') \
        .config('spark.executor.memory', '5gb') \
        .config("spark.cores.max", "6") \
        .getOrCreate()

    sc = spark.sparkContext

    sqlContext = SQLContext(sc)
    # to read parquet file
    df = sqlContext.read.parquet('../../../data/spark/out/deckofcards.parquet')

    df.cache()

    df.select("color", "suit", "face").show(10)

    df.select("color", "suit", "face").groupby("color").count().show()

    df.select("color", "suit", "face").groupby("suit").count().show()

    df.select("color", "suit", "face").groupby("face").count().show()
