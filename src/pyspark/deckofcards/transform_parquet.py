import shutil
from pyspark import SparkContext
from pyspark.sql import SQLContext

if __name__ == "__main__":
    sc = SparkContext(appName="CSV2Parquet")
    sqlContext = SQLContext(sc)

    output_folder = '../../../data/spark/out/deckofcards.parquet'

    try:
        shutil.rmtree(output_folder)
    except OSError as e:
        print("Warning: %s : %s" % (output_folder, e.strerror))

    df = sqlContext.read.csv("../../../data/spark/deckofcards.txt",
                             inferSchema=True,
                             header=True,
                             sep="|")

    df.write.parquet(output_folder)
