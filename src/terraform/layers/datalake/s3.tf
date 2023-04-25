resource "aws_s3_bucket" "resource_name"{
  bucket = "${var.prefix}-datalake-${var.environment}"
  tags = {
    Environment = var.environment,
    Domain = var.domain
    Prefix = var.prefix
  }
}

