import os
import argparse
import pandas as pd
import psycopg2

pg_host = "localhost"
pg_port = 5432
pg_database = "zillow_data"
pg_user = os.getenv("PG_USER")
pg_password = os.getenv("PG_PASSWORD")
input_folder = "zillow_data"  # Folder containing CSV files


# Function to infer PostgreSQL schema from a pandas DataFrame
def infer_pg_schema(df):
    type_mapping = {
        "int64": "INTEGER",
        "float64": "DOUBLE PRECISION",
        "object": "TEXT",
        "bool": "BOOLEAN",
        "datetime64[ns]": "TIMESTAMP",
    }
    schema = []
    for column, dtype in df.dtypes.items():
        pg_type = type_mapping.get(str(dtype), "TEXT")
        schema.append(f'"{column.replace("-", "_")}" {pg_type}')
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
    # Connect to PostgreSQL
    conn = psycopg2.connect(
        host=pg_host,
        port=pg_port,
        user=pg_user,
        password=pg_password,
    )
    cursor = conn.cursor()

    # Process each CSV file in the folder
    for filename in os.listdir(input_folder):
        if filename.endswith(".csv"):
            file_path = os.path.join(input_folder, filename)
            table_name = os.path.splitext(filename)[0]  # Use file name (without extension) as table name

            # Skip tables not matching the selected table
            if selected_table != "all" and table_name.lower() != selected_table.lower():
                continue

            print(f"Processing file: {filename} -> PostgreSQL table: {table_name}")

            # Read the CSV file into a pandas DataFrame
            df = pd.read_csv(file_path)

            # Infer PostgreSQL schema from the DataFrame
            pg_schema = infer_pg_schema(df)

            drop_table_query = f"DROP TABLE IF EXISTS \"{table_name}\";"

            # Construct the CREATE TABLE query
            create_table_query = f"""
            CREATE TABLE IF NOT EXISTS "{table_name}" (
                {pg_schema}
            );
            """
            try:
                # Drop the existing table
                print(f"Dropping PostgreSQL table: {table_name}")
                cursor.execute(drop_table_query)

                # Create the PostgreSQL table
                print(f"Creating PostgreSQL table: {table_name}")
                cursor.execute(create_table_query)
                print(f"PostgreSQL table created: {table_name}")

                # Generate and execute the INSERT INTO query
                insert_query = f"""
                INSERT INTO "{table_name}"
                VALUES
                {generate_insert_values(df)}
                """
                print(f"Inserting data into PostgreSQL table: {table_name}")
                cursor.execute(insert_query)
                conn.commit()
                print(f"Data inserted into table: {table_name}")
            except Exception as e:
                print(f"Error processing table {table_name}: {e}")
                conn.rollback()

    # Close the PostgreSQL connection
    cursor.close()
    conn.close()
    print("All files have been processed and data has been inserted.")


if __name__ == "__main__":
    # Set up argument parser
    parser = argparse.ArgumentParser(description="Process CSV files into PostgreSQL tables.")
    parser.add_argument(
        "--table",
        type=str,
        default="all",
        help="Specify a table name to process, or 'all' to process all tables (default: all).",
    )
    args = parser.parse_args()

    # Process CSV files for the specified table
    process_csv_files(args.table)
