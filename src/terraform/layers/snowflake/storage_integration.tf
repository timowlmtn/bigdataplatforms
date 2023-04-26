resource "snowflake_database" "catalog" {
  name                        = upper("${var.environment}_CATALOG")
  comment                     = "The Database Catalog for Building Data Products using Value Gap Matrix"
  data_retention_time_in_days = 14
}

resource "snowflake_schema" "landing_zone" {
  database = upper("${var.environment}_CATALOG")
  name     = "LANDING_ZONE"
  comment  = "The Landing zone schema for new data"

  is_transient        = false
  is_managed          = false
}

resource "snowflake_storage_integration" "datalake_integration" {
  name    = upper("${var.prefix}_STORAGE_INTEGRATION_DATA_LAKE_${var.environment}")
  comment = "A Storage integration for the datalake"
  type    = "EXTERNAL_STAGE"

  enabled = true

  storage_provider         = "S3"
  storage_aws_role_arn     = "arn:aws:iam::${var.aws_account_id}:role/${var.prefix}-snowflake-data-lake-${var.environment}-${var.domain}"

  storage_allowed_locations = ["s3://${var.prefix}-datalake-${var.environment}/${var.stage_folder}/"]

}