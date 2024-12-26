from mlflow.tracking import MlflowClient

# Initialize MLflow client
client = MlflowClient()

# Register the model
model_uri = "runs:/<run_id>/iris_classifier"
client.create_registered_model("IrisBinaryClassifier")
client.create_model_version(name="IrisBinaryClassifier", source=model_uri, run_id="<run_id>")
