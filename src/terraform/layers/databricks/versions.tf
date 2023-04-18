terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.48.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "1.7.0"
    }
  }
}
