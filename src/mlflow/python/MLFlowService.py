import argparse
from mlflow.tracking import MlflowClient


class MLFlowService:
    def __init__(self, experiment_name):
        """
        Initialize the MLFlowExperiment object with a specific experiment name.

        :param experiment_name: Name of the MLflow experiment to query.
        """
        self.client = MlflowClient()
        self.experiment_name = experiment_name
        self.experiment = self.get_experiment_by_name()

    def get_experiment_by_name(self):
        """
        Retrieve experiment details by name and return as a dictionary.

        :return: A dictionary with experiment details.
        """
        experiment_tuples = self.client.get_experiment_by_name(self.experiment_name)
        if not experiment_tuples:
            raise ValueError(
                f"Experiment with name '{self.experiment_name}' not found."
            )

        experiment_details = {}
        for key, value in experiment_tuples:
            experiment_details[key] = value
        return experiment_details

    def get_last_run_id(self):
        """
        Fetch the last run ID for a given model source from the experiment.

        :return: The last run ID if found, otherwise None.
        """
        if "experiment_id" not in self.experiment:
            raise KeyError("Experiment ID not found in the experiment details.")

        experiment_id = self.experiment["experiment_id"]
        runs = self.client.search_runs(
            experiment_ids=[experiment_id],
            # Uncomment and adjust the filter string if needed:
            # filter_string=f"artifact_uri LIKE '%{model_source}%'",
            order_by=["start_time DESC"],  # Sort by the most recent run
            max_results=1,
        )

        if runs:
            last_run_id = runs[0].info.run_id
            print(
                f"The last run_id for the model source '{self.experiment_name}' is: {last_run_id}"
            )
            return last_run_id
        else:
            print(f"No runs found for the model source '{self.experiment_name}'")
            return None

    def register_model(self, run_id):
        """
        Register a model with a given URI, name, and run ID in the MLflow Model Registry.
            :param run_id: Run ID associated with the model.
        """
        # Register the model in the Model Registry
        self.client.create_registered_model(self.experiment_name)

        model_uri = f"runs:/{run_id}/iris_classifier"
        self.client.create_model_version(
            name=self.experiment_name,
            source=model_uri,
            run_id=run_id,
        )
        print(
            f"Model '{self.experiment_name}' registered successfully with URI '{model_uri}'."
        )


# Example Usage
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="MLflow Experiment Manager")

    parser.add_argument(
        "--name",
        default="iris_classifier",
        help="Name of the MLflow experiment",
    )
    parser.add_argument(
        "--action",
        default="get_run_id",
        choices=["get_run_id", "register"],
        help="Action to perform",
    )

    args = parser.parse_args()

    experiment_name = args.name

    # Initialize the MLFlowExperiment object
    mlflow_experiment = MLFlowService(experiment_name)

    # Fetch the last run ID
    last_run_id = mlflow_experiment.get_last_run_id()

    if args.action == "register":
        mlflow_experiment.register_model(last_run_id)
