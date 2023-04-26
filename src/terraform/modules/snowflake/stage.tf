resource "snowflake_stage" "datalake" {
  name        = var.stage_name
  comment = "Stage for s3://${var.datalake_storage}/${var.stage_folder}"
  url         = "s3://${var.datalake_storage}/${var.stage_folder}"
  database    = var.snowflake_database
  schema      = var.landing_zone_schema
  storage_integration = var.storage_integration
}