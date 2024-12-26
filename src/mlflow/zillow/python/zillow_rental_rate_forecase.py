import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, roc_auc_score, confusion_matrix
import mlflow
import mlflow.sklearn

# Set up MLflow experiment
mlflow.set_experiment("zillow_rental_rate_forecast")

# File paths
data_folder = "../zillow_data"
file_name = "Metro_zordi_uc_sfrcondomfr_month.csv"  # Example file
file_path = f"{data_folder}/{file_name}"


# Load the dataset
def load_and_transform_data(file_path):
    """
    Load the dataset and transform it into long format for time series analysis.
    :param file_path: Path to the CSV file.
    :return: Transformed DataFrame.
    """
    try:
        # Load the CSV file
        data = pd.read_csv(file_path)
        print(f"Data loaded successfully from {file_path}")

        # Melt the DataFrame to convert time series columns into rows
        id_vars = ["RegionID", "SizeRank", "RegionName", "RegionType", "StateName"]
        value_vars = data.columns[5:]  # Columns containing time series data
        data_long = data.melt(id_vars=id_vars, value_vars=value_vars,
                              var_name="Date", value_name="Value")

        # Convert 'Date' to datetime format
        data_long["Date"] = pd.to_datetime(data_long["Date"])

        # Drop rows with missing 'Value'
        data_long = data_long.dropna(subset=["Value"])

        print("Data transformation completed successfully.")
        return data_long
    except Exception as e:
        print(f"Error processing data: {e}")
        return None


# Preprocess data for logistic regression
def preprocess_data(data):
    """
    Prepare data for logistic regression.
    :param data: Transformed long-format DataFrame.
    :return: Feature matrix (X) and target vector (y).
    """
    # Create binary target: Above or below median rental value
    median_value = data["Value"].median()
    data["rent_category"] = (data["Value"] > median_value).astype(int)

    # Select features (metadata and time series value as a feature)
    feature_columns = ["SizeRank", "Value"]
    X = data[feature_columns]
    y = data["rent_category"]

    return X, y


# Train and evaluate logistic regression model
def train_logistic_regression(X, y):
    """
    Train a logistic regression model and evaluate it.
    :param X: Feature matrix.
    :param y: Target vector.
    :return: Trained model, accuracy, and AUC score.
    """
    # Split data into train and test sets
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    # Train logistic regression model
    model = LogisticRegression()
    model.fit(X_train, y_train)

    # Evaluate model
    y_pred = model.predict(X_test)
    y_pred_prob = model.predict_proba(X_test)[:, 1]
    accuracy = accuracy_score(y_test, y_pred)
    auc = roc_auc_score(y_test, y_pred_prob)

    print(f"Accuracy: {accuracy}")
    print(f"AUC: {auc}")
    print("Confusion Matrix:")
    print(confusion_matrix(y_test, y_pred))

    return model, accuracy, auc


# Run the experiment
def run_experiment(file_path):
    """
    Run the experiment by loading data, preprocessing it, training a model,
    and logging results with MLflow.
    :param file_path: Path to the data file.
    """
    data = load_and_transform_data(file_path)
    if data is None:
        return

    X, y = preprocess_data(data)

    with mlflow.start_run():
        # Train the model
        model, accuracy, auc = train_logistic_regression(X, y)

        # Log parameters, metrics, and the model
        mlflow.log_param("features", list(X.columns))
        mlflow.log_metric("accuracy", accuracy)
        mlflow.log_metric("auc", auc)
        mlflow.sklearn.log_model(model, "logistic_regression_model")

        print("Experiment logged successfully.")


# Main entry point
if __name__ == "__main__":
    run_experiment(file_path)
