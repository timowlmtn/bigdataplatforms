data "aws_iam_policy_document" "databricks_s3_stage" {

  # Bucket metadata
  statement {
    sid = "PermissionsToReadStageBucket"

    effect = "Allow"

    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]

    resources = [
      "arn:aws:s3:::${var.aws_data_stage_bucket}"
    ]
  }

  # Read objects in the data lake bucket
  statement {

    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObjectAcl"
    ]

    resources = [
      "arn:aws:s3:::${var.aws_data_stage_bucket}/${var.aws_data_stage_folder}/*"
    ]
  }
}

resource "aws_iam_policy" "databricks_stage_policy" {
  name = "owlmtn-databricks-s3-stage"
  description = "A policy to allow databricks to access the Stage"
  policy = data.aws_iam_policy_document.databricks_s3_stage.json

}


resource "aws_iam_role_policy" "databricks" {
  name     = "policy"
  policy   = data.aws_iam_policy_document.databricks_s3_stage.json
  role     = aws_iam_role.databricks.id
}

resource "aws_iam_role" "databricks" {
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": var.databricks_principal
            },
            "Action": "sts:AssumeRole",
            "Condition": {
                "StringEquals": {
                    "sts:ExternalId": var.databricks_account_id
                }
            }
        }
    ]
})

  name               = "${var.prefix}-databricks"
}


