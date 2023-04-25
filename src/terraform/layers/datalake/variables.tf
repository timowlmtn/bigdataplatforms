variable "region" {
  description = "AWS specific region"
  type        = string
  default     = "us-east-1"
}

variable "prefix" {
  description = "A unique prefix for the project."
  type = string
}

variable "domain" {
  description = "The domain of the project."
  type = string
}


variable "environment" {
  description = "The environment for the project"
  type = string
}


variable "aws_account_id" {
  description = "The AWS account ID"
  type = string
}