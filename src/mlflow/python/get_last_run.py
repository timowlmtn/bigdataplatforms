from mlflow.tracking import MlflowClient

# Initialize the MLflow client
client = MlflowClient()

# Define the model source path to search for
model_source = "iris_classifier"  # Adjust based on your artifact path

# List all experiments
experiment_tuples = client.get_experiment_by_name('Default')

# Iterate through experiments to find runs
last_run_id = None

experiment = {}

for tuple in experiment_tuples:
    # Search all runs in the experiment
    print(tuple)
    experiment[tuple[0]] = tuple[1]

runs = client.search_runs(
    experiment_ids=[experiment["experiment_id"]],
    # filter_string=f"artifact_uri LIKE '%{model_source}%'",
    order_by=["start_time DESC"],  # Sort by the most recent run
    max_results=1
)
print(runs)
if runs:
    # Extract the last run_id from the results
    last_run_id = runs[0].info.run_id

if last_run_id:
    print(f"The last run_id for the model source '{model_source}' is: {last_run_id}")
else:
    print(f"No runs found for the model source '{model_source}'")
