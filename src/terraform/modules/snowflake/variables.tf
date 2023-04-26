variable "datalake_storage" {
  description = "The Data Lake Storage "
  type = string
}

variable "stage_name" {
  description = "The name for the stage"
  type = string
}

variable "stage_folder" {
  description = "The folder for the stage"
  type = string
}

variable "snowflake_database" {
  description = "The database name"
  type = string
}

variable "landing_zone_schema" {
  description = "The database schema for the landing zone data"
  type = string
}

variable "storage_integration" {
  description = "The storage integration created in Snowflake"
  type = string
}