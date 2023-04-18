variable "region" {
  description = "AWS specific region"
  type        = string
  default     = "us-east-1"
}

variable "prefix" {
  description = "A unique prefix for the project."
  type = string
}
