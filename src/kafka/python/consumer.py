from kafka import KafkaConsumer

# Initialize Kafka Consumer
consumer = KafkaConsumer(
    'hello-world',
    bootstrap_servers='localhost:9092',
    auto_offset_reset='earliest',
    enable_auto_commit=True,
    group_id='my-group'
)

print("Waiting for messages...")
for message in consumer:
    print(f"Received message: {message.value.decode('utf-8')}")
