# Step 1: Import Libraries
import os
import mlflow.sklearn
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score

# Step 2: Load and Prepare the Data
# For simplicity, we’ll use Iris dataset and make it binary
data = load_iris()
X = data.data
y = (data.target == 2).astype(
    int
)  # Binary classification (1 if Iris-Virginica, else 0)

# Split the data into training and test sets
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

# Step 3: Configure MLflow Tracking URI (Optional)
mlflow.set_tracking_uri(os.getenv("MLFLOW_TRACKING_URI"))

mlflow.set_experiment("iris_classifier")

# Step 4: Start an MLflow Run
with mlflow.start_run():
    # Step 5: Model Training
    model = LogisticRegression(max_iter=100)
    model.fit(X_train, y_train)

    # Step 6: Model Evaluation
    y_pred = model.predict(X_test)
    accuracy = accuracy_score(y_test, y_pred)

    # Step 7: Log parameters, metrics, and model with MLflow
    mlflow.log_param("model_type", "LogisticRegression")
    mlflow.log_param("max_iter", 100)
    mlflow.log_metric("accuracy", accuracy)

    # Log the model itself
    mlflow.sklearn.log_model(
        sk_model=model,
        artifact_path="iris_classifier",
        registered_model_name="iris_classifier",
    )

print(f"Model logged with accuracy: {accuracy}")
