variable "aws_region" {
  description = "The AWS region where the backend resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "s3_bucket_name" {
  description = "A globally unique name for the S3 bucket that will store Terraform state files. Choose a name specific to your organization."
  type        = string
  # No default - this must be provided by the user to ensure uniqueness.
}

variable "tags" {
  description = "A map of tags to assign to all created resources for identification and cost allocation."
  type        = map(string)
  default = {
    Project     = "Terraform-Backend"
    ManagedBy   = "Terraform"
    Environment = "Internal"
  }
}
