resource "aws_iam_role" "snowflake_s3_reader" {
  name               = "${var.storage_integration_name}_snowflake_si_role"
  assume_role_policy = "${file("assume_role_policy.json")}"
}
