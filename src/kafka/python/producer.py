from kafka import KafkaProducer
from datetime import datetime
import json

# Initialize Kafka Producer
producer = KafkaProducer(
    bootstrap_servers='localhost:9092',
    value_serializer=lambda v: json.dumps(v).encode('utf-8')  # Serialize messages as JSON
)

# Get current timestamp in ISO format (to the second)
timestamp = datetime.utcnow().isoformat(timespec='seconds')

# Construct message with timestamp
message = {
    "message": "Hello, Kafka!",
    "timestamp": timestamp
}

# Send message
producer.send('hello-world', message)
producer.flush()

print(f"Message sent successfully! {message}")
