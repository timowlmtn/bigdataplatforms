variable "region" {
  description = "AWS specific region"
  type        = string
  default = "us-east-1"
}

variable "aws_data_stage_bucket" {
  description = "AWS stage bucket"
  type = string
}

variable "aws_data_stage_folder" {
  description = "AWS stage folder"
  type = string
}

variable "prefix" {
  description = "A unique prefix"
  type = string
}

variable "aws_databricks_role" {
  description = "The databricks role identifier"
  type = string
}

variable "databricks_principal" {
  description = "Principal identifier for databricks"
  type = string
}

variable "databricks_account_id" {
  description = "Account Id that could be found in the bottom left corner of https://accounts.cloud.databricks.com/"
  type = string
}