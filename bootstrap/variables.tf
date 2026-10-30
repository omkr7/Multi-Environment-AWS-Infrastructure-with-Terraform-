variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state."
  type        = string
}

variable "lock_table_name" {
  type    = string
  default = "terraform-state-locks"
}
