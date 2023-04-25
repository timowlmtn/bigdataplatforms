resource "aws_s3_bucket" "datalake_s3_resource"{
  bucket = "${var.prefix}-datalake-${var.environment}"
  tags = {
    Environment = var.environment,
    Domain = var.domain
    Prefix = var.prefix
  }
}

