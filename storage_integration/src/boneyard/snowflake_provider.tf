terraform {
  required_providers {
    snowflake = {
      source = "chanzuckerberg/snowflake"
      version = "<desired-version>"
    }
  }
}

provider "snowflake" {
  account   = "${var.snowflake-account}"
  user      = "${var.snowflake-username}"
  password  = "${var.snowflake-password}"
  role      = "${var.snowflake-role}"
  warehouse = "${var.snowflake-warehouse}"
  database  = "${var.snowflake-database}"
}