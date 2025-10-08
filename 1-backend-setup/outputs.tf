output "s3_bucket_name" {
  description = "The name of the S3 bucket created for Terraform state storage."
  value       = aws_s3_bucket.terraform_state.id
}

output "kms_key_arn" {
  description = "The ARN of the KMS key created for state file encryption."
  value       = aws_kms_key.terraform_state_encryption.arn
}
