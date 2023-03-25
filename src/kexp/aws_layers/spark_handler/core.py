# ------------------------------------------------
# Spark Core Handler Class
#
#  This program wraps common Spark Functionality.
#
# ------------------------------------------------
# License: Apache 2.0
# ------------------------------------------------
# Author: Tim Burns
# Copyright: 2023, Big Data Platforms
# Credits: [KEXP and developers]
# Version: 0.0.1
# Maintainer: Tim Burns
# Email: timburnsowlmtn@gmail.com
# Status: Demo Code
# ------------------------------------------------

from pyspark.sql import SparkSession
from delta import *

from os import listdir
from os.path import join
import fnmatch
import shutil


class SparkCore:
    app_name = None
    bronze_location = None
    silver_location = None
    gold_location = None

    spark = None
    sql_context = None

    def __init__(self, app_name, root_location):
        self.app_name = app_name
        self.bronze_location = f"{root_location}/bronze"
        self.silver_location = f"{root_location}/silver"
        self.gold_location = f"{root_location}/gold"

        builder = SparkSession.builder.appName(app_name) \
            .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension") \
            .config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog")

        self.spark = configure_spark_with_delta_pip(builder).getOrCreate()

    def process_raw_to_bronze(self, raw_data_folder, file_match):
        result = {"raw": [], "bronze": []}

        spark = SparkSession.builder.getOrCreate()

        for file in fnmatch.filter(listdir(raw_data_folder), file_match):
            result["raw"].append(join(raw_data_folder, file))

            (file_name, file_type) = file.split(".")

            df = spark.read.load(join(raw_data_folder, file),
                                 format=file_type, inferSchema="true", header="true")

            try:
                shutil.rmtree(join(self.bronze_location, file_name))
            except OSError as e:
                print("Warning: %s : %s" % (join(self.bronze_location, file_name), e.strerror))

            df.write.format("delta").save(join(self.bronze_location, file_name))

            result["bronze"].append(join(self.bronze_location, file_name))

        return result
