resource "aws_iam_role" "snowflake_s3_reader" {
  name               = "${var.storage-integration-name}_snowflake_si_role"
  assume_role_policy = "${file("assume_role_policy.json")}"
}
