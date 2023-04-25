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

  name = "${var.prefix}-snowflake-data-lake-${var.environment}-${var.domain}"

}


data "aws_iam_policy_document" "snowflake" {

  # Bucket metadata
  statement {
    actions = [
      "s3:ListBucketMultipartUploads",
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]

    resources = [
      "${aws_s3_bucket.datalake_s3_resource.arn}/stage/*"
    ]
  }

  # Read objects in the data lake bucket
  statement {
    actions = [
        "s3:PutObject",
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:DeleteObject",
        "s3:DeleteObjectVersion"
    ]

    resources = [
      "${aws_s3_bucket.datalake_s3_resource.arn}/stage/*"
    ]
  }
}

resource "aws_iam_role_policy" "snowflake" {
  name     = "policy-read-write-datalake"
  policy   = data.aws_iam_policy_document.snowflake.json
  role     = aws_iam_role.snowflake.name
}
