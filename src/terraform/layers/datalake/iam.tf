module "snowflake_storage_integration" {
  source = "../snowflake"
  aws_account_id = var.aws_account_id
  environment = var.environment
  prefix = var.prefix
  region = var.region
  domain = var.domain
}

resource "aws_iam_role" "snowflake" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = module.snowflake_storage_integration.storage_aws_iam_user_arn
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = module.snowflake_storage_integration.storage_aws_external_id
          }
        }
      }
    ]
  })

  name               = "${var.prefix}-snowflake-data-lake-${var.environment}-${var.domain}"

}
