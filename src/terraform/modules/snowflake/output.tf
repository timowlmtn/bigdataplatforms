output "datalake_stage" {
  description = "The Name of the snowflake stage object"
  value = snowflake_stage.datalake.name
}