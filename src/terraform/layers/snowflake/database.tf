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