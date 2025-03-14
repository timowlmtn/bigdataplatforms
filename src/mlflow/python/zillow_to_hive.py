import os
import argparse
import pandas as pd
from pyhive import hive

# Hive connection details
hive_host = "localhost"
hive_port = 10000
hive_database = "zillow_data"
input_folder = "zillow_data"  # Folder containing CSV files


# Function to infer Hive schema from a pandas DataFrame
def infer_hive_schema(df):
    type_mapping = {
        "int64": "INT",
        "float64": "DOUBLE",
        "object": "STRING",
        "bool": "BOOLEAN",
        "datetime64[ns]": "TIMESTAMP",
    }
    schema = []
    for column, dtype in df.dtypes.items():
        hive_type = type_mapping.get(str(dtype), "STRING")
        schema.append(f"{column.replace('-', '_')} {hive_type}")
    return ",\n    ".join(schema)


def process_value(value):
    if isinstance(value, str):
        # Replace single quotes with two single quotes and wrap in single quotes
        value = value.replace("'", "''")
        return f"'{value}'"
    elif pd.isna(value):
        # Return NULL for NaN values
        return "NULL"
    else:
        # Convert other types to string
        return str(value)


# Function to generate SQL insert values
def generate_insert_values(df):
    values = []
    for _, row in df.iterrows():
        row_values = [process_value(value) for value in row]

        values.append(f"({', '.join(row_values)})")
    return ",\n".join(values)


def process_csv_files(selected_table):
    # Connect to Hive
    conn = hive.Connection(host=hive_host, port=hive_port, username="hive")
    cursor = conn.cursor()

    # Ensure the Hive database exists
    cursor.execute(f"CREATE DATABASE IF NOT EXISTS {hive_database}")
    cursor.execute(f"USE {hive_database}")

    # Process each CSV file in the folder
    for filename in os.listdir(input_folder):
        if filename.endswith(".csv"):
            file_path = os.path.join(input_folder, filename)
            table_name = os.path.splitext(filename)[
                0
            ]  # Use file name (without extension) as table name

            # Skip tables not matching the selected table
            if selected_table != "all" and table_name.lower() != selected_table.lower():
                continue

            print(f"Processing file: {filename} -> Hive table: {table_name}")

            # Read the CSV file into a pandas DataFrame
            df = pd.read_csv(file_path)

            # Infer Hive schema from the DataFrame
            hive_schema = infer_hive_schema(df)

            drop_table = f"DROP TABLE IF EXISTS {hive_database}.{table_name}"

            # Construct the CREATE TABLE query
            create_table_query = f"""
            CREATE TABLE IF NOT EXISTS {table_name} (
                {hive_schema}
            )
            """
            try:
                # Drop the existing table
                print(f"Dropping Hive table: {table_name}")
                cursor.execute(drop_table)

                # Create the Hive table
                print(f"Creating Hive table: {table_name}")
                cursor.execute(create_table_query)
                print(f"Hive table created: {table_name}")

                # Generate and execute the INSERT INTO query
                insert_query = f"""
                INSERT INTO {table_name}
                VALUES
                {generate_insert_values(df)}
                """
                print(f"Inserting data into Hive table: {table_name}")
                # print(insert_query)
                cursor.execute(insert_query)
                print(f"Data inserted into table: {table_name}")
            except Exception as e:
                print(f"Error processing table {table_name}: {e}")

    # Close the Hive connection
    cursor.close()
    conn.close()
    print("All files have been processed and data has been inserted.")


if __name__ == "__main__":
    # Set up argument parser
    parser = argparse.ArgumentParser(description="Process CSV files into Hive tables.")
    parser.add_argument(
        "--table",
        type=str,
        default="all",
        help="Specify a table name to process, or 'all' to process all tables (default: all).",
    )
    args = parser.parse_args()

    # Process CSV files for the specified table
    process_csv_files(args.table)
