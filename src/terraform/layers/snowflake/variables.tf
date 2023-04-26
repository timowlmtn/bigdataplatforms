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

variable "stage_folder" {
  description = "A default root folder for staging data in the lake"
  type = string
  default = "stage"
}

variable "landing_zone_schema" {
  description = "The Schema for the Landing Zone"
  type = string
  default = "LANDING_ZONE"
}