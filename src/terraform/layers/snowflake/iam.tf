resource "aws_iam_role" "snowflake" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = snowflake_storage_integration.datalake_integration.storage_aws_iam_user_arn
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" = snowflake_storage_integration.datalake_integration.storage_aws_external_id
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
      "arn:aws:s3:::${var.prefix}-datalake-${var.environment}",
      "arn:aws:s3:::${var.prefix}-datalake-${var.environment}/*"
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
      "arn:aws:s3:::${var.prefix}-datalake-${var.environment}/${var.stage_folder}/*"
    ]
  }
}

resource "aws_iam_role_policy" "snowflake" {
  name     = "policy-read-write-datalake"
  policy   = data.aws_iam_policy_document.snowflake.json
  role     = aws_iam_role.snowflake.name
}


