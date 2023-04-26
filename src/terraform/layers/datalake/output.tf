output "bucket_arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = aws_s3_bucket.datalake_s3_resource.arn
}

output "bucket_url" {
  description = "The URL of the bucket"
  value       = "${var.prefix}-datalake-${var.environment}"
}
