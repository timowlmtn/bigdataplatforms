output "storage_integration_name" {
  description = "Name of Storage integration"
  value       = snowflake_storage_integration.datalake_integration.name
}

output "storage_aws_iam_user_arn" {
  description = "The IAM user for the Snowflake AWS Principal"
  value       = snowflake_storage_integration.datalake_integration.storage_aws_iam_user_arn
}

output "storage_aws_external_id" {
  description = "The IAM user for the Snowflake Storage Integration External ID"
  value       = snowflake_storage_integration.datalake_integration.storage_aws_external_id
}
