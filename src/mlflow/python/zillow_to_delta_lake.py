from delta import configure_spark_with_delta_pip
from pyspark.sql import SparkSession

import os


def csv_to_delta(input_folder, output_folder):
    # Initialize Spark session with Delta Lake
    builder = (
        SparkSession.builder.appName("CSV to Delta Example")
        .config("spark.driver.extraJavaOptions", "-Djava.security.manager=allow")
        .config("spark.executor.extraJavaOptions", "-Djava.security.manager=allow")
        .config("spark.sql.extensions", "io.delta.sql.DeltaSparkSessionExtension")
        .config(
            "spark.sql.catalog.spark_catalog",
            "org.apache.spark.sql.delta.catalog.DeltaCatalog",
        )
    )

    spark = configure_spark_with_delta_pip(builder).getOrCreate()

    # Ensure output folder exists
    os.makedirs(output_folder, exist_ok=True)

    # Iterate over all CSV files in the input folder
    for filename in os.listdir(input_folder):
        if filename.endswith(".csv"):
            file_path = os.path.join(input_folder, filename)

            # Generate a Delta table name based on the CSV filename
            table_name = os.path.splitext(filename)[0]  # Remove the '.csv' extension
            delta_table_path = os.path.join(output_folder, table_name)

            print(f"Processing file: {filename} -> Delta table: {table_name}")

            # Read the CSV file into a Spark DataFrame
            df = (
                spark.read.format("csv")
                .option("header", "true")
                .option("inferSchema", "true")
                .load(file_path)
            )

            # Write the DataFrame as a Delta table
            df.write.format("delta").mode("overwrite").save(delta_table_path)

            print(f"Delta table saved at: {delta_table_path}")

    # Stop the Spark session
    spark.stop()
    print("All files have been processed and converted to Delta tables.")


if __name__ == "__main__":
    # Replace with your actual paths
    input_csv_path = "zillow_data"  # Folder containing CSV files
    delta_output_path = "zillow_delta"  # Local Delta Lake storage

    csv_to_delta(input_csv_path, delta_output_path)
