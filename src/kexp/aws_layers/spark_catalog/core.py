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
import fnmatch
import json
import os
import shutil
from os import listdir
from os.path import join
import re

from delta import *
from pyspark.sql import SQLContext
from pyspark.sql import SparkSession
from pyspark.sql.functions import col, explode, regexp_replace, split
from pyspark.sql.types import IntegerType


class SparkCatalog:
    app_name = None

    raw_location = None
    bronze_location = None
    silver_location = None
    gold_location = None

    spark = None
    sql_context = None

    catalog = {}
    catalog_metadata = {}

    def __init__(self, app_name, lake_location, raw_location=None):
        self.app_name = app_name
        self.raw_location = raw_location
        self.bronze_location = f"{lake_location}/bronze"
        self.silver_location = f"{lake_location}/silver"
        self.gold_location = f"{lake_location}/gold"

        builder = SparkSession.builder.appName(app_name) \
            .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension") \
            .config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog")

        self.spark = configure_spark_with_delta_pip(builder).getOrCreate()
        self.sql_context = SQLContext(self.spark.sparkContext)

    def append_bronze(self, raw_file_match, table_name, change_column_id):
        result = {"raw": [], "bronze": []}
        for file in fnmatch.filter(listdir(self.raw_location), raw_file_match):

            result["raw"].append(file)

            source_data = self.spark.read.load(join(self.raw_location, file),
                                               format=self.get_file_type(file), inferSchema="true", header="true")

            schema = self.infer_schema_raw(file)

            target_table = self.get_bronze_data_frame(table_name)

            max_id = 0
            if target_table:
                max_id = self.get_max_integer(target_table, column_name=change_column_id)

            for column in source_data.columns:
                source_data = source_data.withColumn(column, source_data[column].cast(schema[column]))

            new_data = source_data.filter(f'{change_column_id} > {max_id}')

            if new_data.count() > 0:
                table_full_path = join(self.bronze_location, table_name)
                result["bronze"].append(table_full_path)
                result["status"] = f"Saving {new_data.count()} records to {table_full_path}."
                new_data.write.mode("append").format("delta").save(table_full_path)
            else:
                result["status"] = f"No new data found for {raw_file_match}."

        return result

    def delete(self, file_full_path):
        try:
            shutil.rmtree(file_full_path)
        except OSError as e:
            print("Warning: %s : %s" % (join(self.bronze_location, file_full_path), e.strerror))

    def get_table(self, table_path):
        result = None
        if table_path in self.catalog:
            result = self.catalog[table_path]
        else:
            if os.path.exists(table_path):
                self.catalog[table_path] = DeltaTable.forPath(self.spark, table_path)
                result = self.catalog[table_path]
        return result

    def get_data_frame(self, table_path):
        table = self.get_table(table_path)
        if table is not None:
            result = table.toDF()
        else:
            result = None
        return result

    def get_bronze_data_frame(self, table_name):
        table = self.get_table(join(self.bronze_location, table_name))
        if table is not None:
            result = table.toDF()
        else:
            result = None
        return result

    @staticmethod
    def get_file_type(file):
        split_file = re.match(r"(.*)\.([a-z]+)$", file)
        return split_file.group(2)

    @staticmethod
    def get_max_integer(df, column_name):
        row = df.withColumn(column_name, df[column_name].cast(IntegerType())).agg({column_name: "max"}).first()
        return row[0]

    def get_silver_df(self, table_name):
        return self.get_data_frame(join(self.silver_location, table_name))

    def get_metadata(self, table_path):
        if table_path not in self.catalog_metadata:
            delta_dir = join(table_path, "_delta_log")
            for file in os.listdir(delta_dir):
                if file.endswith(".json"):

                    with open(join(delta_dir, file)) as json_file:

                        for json_line in json_file:
                            json_obj = json.loads(json_line)
                            if "metaData" in json_obj:
                                self.catalog_metadata[table_path] = json_obj["metaData"]
                                break

        return self.catalog_metadata[table_path]

    def get_schema(self, table_path):
        metadata = self.get_metadata(table_path)
        result = None
        if metadata is not None:
            schema_string = metadata["schemaString"]
            result = json.JSONDecoder().decode(schema_string)

        return result

    def infer_schema_raw(self, raw_file_match):
        file = join(self.raw_location, raw_file_match)
        source_data = self.sql_context.read.load(file,
                                                 format=self.get_file_type(file),
                                                 inferSchema="true",
                                                 header="true").limit(3)
        result = {}

        for row in source_data.collect():
            for column in row.asDict():
                if column not in result:
                    default_type = "string"
                    if column.endswith("_DATE"):
                        default_type = "date"
                    elif column.endswith("_TIMESTAMP"):
                        default_type = "timestamp"
                    elif column.endswith("_DATETIME"):
                        default_type = "datetime"
                    elif column.endswith("_ID" or column.endswith("_KEY")):
                        default_type = "integer"
                    result[column] = default_type

                # print(f"{column}: {row[column]}")

                # Update timestamp if it matches
                if row[column]:
                    if re.match(r"[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-9]{3} [\-\+]?[0-9]{4}",
                                row[column]):
                        result[column] = "timestamp"

        return result

    def sql(self, sql_statement):
        return self.sql_context.sql(sql_statement)

    def explode(self, table_df, column_name, target_name, column_separating=", "):
        table_df.withColumn(
            column_name,
            explode(split(regexp_replace(col(column_name), "(^\[)|(\]$)", ""), column_separating))
        ).write.mode("overwrite").format("delta").save(join(self.silver_location, target_name))

    def truncate_bronze(self, table_name):
        self.delete(join(self.bronze_location, table_name))

    def truncate_silver(self, table_name):
        self.delete(join(self.silver_location, table_name))
