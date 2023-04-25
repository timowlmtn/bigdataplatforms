resource "snowflake_database" "catalog" {
  name                        = upper("${var.environment}_CATALOG")
  comment                     = "The Database Catalog for Building Data Products using Value Gap Matrix"
  data_retention_time_in_days = 14
}