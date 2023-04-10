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
from os.path import join
import re

from delta import *
from pyspark.sql import SQLContext
from pyspark.sql.functions import col, explode, regexp_replace, split, lit, unix_timestamp
from pyspark.sql.types import IntegerType
from delta.tables import *
import time
import datetime

class SparkCatalog:
    source_name = None

    raw_location = None
    bronze_location = None
    silver_location = None
    gold_location = None

    spark = None
    sql_context = None

    catalog = {}
    catalog_metadata = {}
    catalog_schemas = {}

    def __init__(self, source_name, lake_location, raw_location=None):
        self.source_name = source_name
        self.raw_location = raw_location
        self.lake_location = lake_location

        builder = SparkSession.builder.appName(source_name) \
            .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension") \
            .config("spark.sql.catalog.spark_catalog", "org.apache.spark.sql.delta.catalog.DeltaCatalog")

        self.spark = configure_spark_with_delta_pip(builder).getOrCreate()
        self.sql_context = SQLContext(self.spark.sparkContext)

    def append_bronze(self, raw_file_match, table_name, change_column_id):
        """
        Appends to the bronze location.

        @param raw_file_match: A regular expression in the raw directory to match.
        @param table_name: The table_name (folder) in the bronze output.
        @param change_column_id: A change column from the raw_file_match folder to indicate changes.

        @return: A JSON object describing the files affected the operation.

        """
        result = {"raw": [], "bronze": []}

        (root_folder, target_file) = raw_file_match.split("/**/")
        for root, folder, files in sorted(os.walk(os.path.join(self.raw_location, root_folder))):
            # print(f"DEBUG: {root} {folder}")
            for item in fnmatch.filter(files, target_file):
                file = os.path.join(root, item)
                source_data = self.spark.read.load(file,
                                                   format=self.get_file_type(file),
                                                   inferSchema="true",
                                                   header="true")

                schema = self.infer_schema_raw(table_name, file)

                max_id = self.max(table_schema="bronze", table_name=table_name, column_name=change_column_id)

                if max_id is None:
                    max_id = 0

                for column in source_data.columns:
                    # print(f"DEBUG: {column} {source_data[column]} --> {schema[column]} {file}")
                    source_data = source_data.withColumn(column, source_data[column].cast(schema[column]))

                new_data = source_data.filter(f'{change_column_id} > {max_id}')

                # print(f"DEBUG: {file} {max_id} {new_data.count()} --> {table_name}")

                if new_data.count() > 0:
                    table_full_path = os.path.join(os.path.join(self.lake_location, "bronze"), table_name)
                    result["raw"].append(file)
                    result["bronze"].append(f"Saving {new_data.count()} records to {table_full_path}")
                    new_data.write.mode("append").format("delta").save(table_full_path)

        return result

    def delete(self, file_full_path):
        try:
            shutil.rmtree(file_full_path)
        except OSError as e:
            print("Warning: %s : %s" % (join(self.bronze_location, file_full_path), e.strerror))

    def get_table_path(self, table_schema, table_name):
        table_path_lookup = {
            "bronze": os.path.join(self.lake_location, "bronze"),
            "silver": os.path.join(self.lake_location, "silver"),
            "gold": os.path.join(self.lake_location, "gold")
        }

        table_path = os.path.join(table_path_lookup[table_schema], table_name)

        return table_path

    def get_delta_table(self, table_schema, table_name):
        result = None

        table_path = self.get_table_path(table_schema, table_name)

        if table_path in self.catalog:
            result = self.catalog[table_path]
        else:
            if os.path.exists(table_path):
                delta_table = DeltaTable.forPath(self.spark, table_path)
                self.catalog[table_path] = delta_table
                result = self.catalog[table_path]
        return result

    def get_data_frame(self, table_schema, table_name):
        table = self.get_delta_table(table_schema, table_name)
        if table is not None:
            data_frame = table.toDF()
            data_frame.createOrReplaceTempView(table_name)
        else:
            data_frame = None
        return data_frame

    @staticmethod
    def get_file_type(file):
        split_file = re.match(r"(.*)\.([a-z]+)$", file)
        result = split_file.group(2)
        if result == "jsonl":
            result = "json"

        return result

    @staticmethod
    def get_max_integer(df, column_name):
        row = df.withColumn(column_name, df[column_name].cast(IntegerType())).agg({column_name: "max"}).first()
        return row[0]

    def get_metadata(self, table_schema, table_name):
        table_path = self.get_table_path(table_schema, table_name)
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

    def get_schema(self, table_schema, table_name):
        metadata = self.get_metadata(table_schema, table_name)
        result = None
        if metadata is not None:
            schema_string = metadata["schemaString"]
            result = json.JSONDecoder().decode(schema_string)

        return result

    def infer_schema_raw(self, table_name, raw_file_match):
        if table_name in self.catalog_schemas:
            return self.catalog_schemas[table_name]
        else:
            file = join(self.raw_location, raw_file_match)
            source_data = self.sql_context.read.load(file,
                                                     format=self.get_file_type(file),
                                                     inferSchema="true",
                                                     header="true").limit(20)
            result = {}

            for row in source_data.collect():
                for column in row.asDict():
                    if column not in result:
                        if row[column] is not None:
                            if type(row[column]) == str:
                                default_type = "string"
                            elif type(row[column]) == int:
                                default_type = "integer"
                            elif type(row[column]) == bool:
                                default_type = "boolean"
                            elif type(row[column]) == list:
                                default_type = "array<string>"
                            else:
                                default_type = type(row[column]).__name__
                        else:
                            default_type = "string"

                        if column.upper().endswith("_DATE"):
                            default_type = "date"
                        elif column.upper().endswith("_TIMESTAMP"):
                            default_type = "timestamp"
                        elif column.upper().endswith("_DATETIME"):
                            default_type = "datetime"
                        elif column.upper().endswith("_ID" or column.endswith("_KEY")):
                            default_type = "integer"

                        result[column] = default_type

                    # Update timestamp if it matches
                    if row[column]:
                        if type(row[column]) == str:
                            if re.match(r"[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-9]{3} [\-\+]?[0-9]{4}",
                                        row[column]):
                                result[column] = "timestamp"
                            elif re.match(r"[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}[\-\+]?[0-9]{2}:[0-9]{2}",
                                          row[column]):
                                result[column] = "timestamp"

                    # print(f"DEBUG: {column}: {row[column]} {type(row[column])} --> {result[column]}")
            # Cache the schema definitions
            self.catalog_schemas[table_name] = result

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

    def max(self, table_schema, table_name, column_name):
        data_frame = self.get_data_frame(table_schema, table_name)

        max_id = None
        if data_frame:
            max_id = self.get_max_integer(data_frame, column_name=column_name)

        return max_id

    def add_default_columns(self, table_data_frame):
        result = table_data_frame.withColumn("catalog_source", lit(self.source_name))
        timestamp = datetime.datetime.fromtimestamp(time.time()).strftime('%Y-%m-%d %H:%M:%S')
        result = result.withColumn("catalog_timestamp",
                                   unix_timestamp(lit(timestamp), 'yyyy-MM-dd HH:mm:ss').cast("timestamp"))
        return result

    def append_changed(self, data_frame, table_schema, table_name, identifier_columns):
        data_frame = data_frame.alias('df1')

        new_dataframe = self.get_data_frame(table_schema, table_name)
        changes = data_frame
        if new_dataframe is not None:
            new_dataframe = new_dataframe.alias('df2')
            all_data = data_frame.join(new_dataframe, identifier_columns, "outer")
            identifier_values = list(map(lambda x: f'df1.{x} != df2.{x}', identifier_columns))
            identifier_columns = " and ".join(identifier_values)
            changes = all_data.select("df1.*").filter(identifier_columns)

        result = {table_schema: []}
        if changes.count() > 0:
            output_file = os.path.join(os.path.join(self.lake_location, table_schema), table_name)
            changes = self.add_default_columns(changes)
            changes.write.mode("append").format("delta").save(output_file)
            result[table_schema].append(f"Saving {changes.count()} records to {output_file}")
        else:
            result[table_schema].append(f"No changes detected for {table_name}")

        return result

