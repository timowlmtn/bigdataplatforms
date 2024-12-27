from pyhive import hive

# Connect to Hive
conn = hive.Connection(
    host='localhost',       # Replace with the hostname or IP of your Hive server
    port=10000,             # Default Hive Thrift port
    username='hive',        # Your Hive username
    database='default'      # Hive database name
)

# Execute a query
cursor = conn.cursor()
cursor.execute("SHOW TABLES")

# Fetch and print results
for table in cursor.fetchall():
    print(table)

# Close the connection
conn.close()
