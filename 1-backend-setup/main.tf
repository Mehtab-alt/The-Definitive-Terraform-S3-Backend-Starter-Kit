provider "aws" {
  region = var.aws_region
}

# --- 1. The Secure Vault (S3 Bucket) ---
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.s3_bucket_name
  tags   = var.tags

  # This lifecycle block is a critical safety measure that prevents Terraform
  # from accidentally deleting the bucket, which would destroy all state files.
  lifecycle {
    prevent_destroy = true
  }
}

# --- 2. Archival History (S3 Bucket Versioning) ---
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# --- 3. The Vault's Security Guard (Block Public Access) ---
resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# --- 4. The Vault's Encryption (KMS Key) ---
resource "aws_kms_key" "terraform_state_encryption" {
  description             = "KMS key for encrypting Terraform state files"
  deletion_window_in_days = 7
  tags                    = var.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.terraform_state_encryption.arn
    }
  }
}

# --- 5. (Optional) Migrate this project's own state to the new backend ---
# After you run 'terraform apply' once, uncomment this block, fill in your
# bucket name, and run 'terraform init' again. This will prompt you
# to migrate this project's state file into the backend it just created.
#
# terraform {
#   backend "s3" {
#     bucket  = "your-unique-bucket-name-here" # Replace with your bucket name
#     key     = "internal/backend-setup.tfstate"
#     region  = "us-east-1"
#     encrypt = true
#   }
# }

# --- 6. (Optional) State Archival & Cost Management ---
# Uncomment this block to automatically manage old state versions to save costs.
#
# resource "aws_s3_bucket_lifecycle_configuration" "state_lifecycle" {
#   bucket = aws_s3_bucket.terraform_state.id
#
#   rule {
#     id     = "ArchiveOldStateVersions"
#     status = "Enabled"
#
#     filter {}
#
#     # After 30 days, move non-current (old) versions to a cheaper storage class.
#     noncurrent_version_transition {
#       noncurrent_days = 30
#       storage_class   = "STANDARD_IA"
#     }
#
#     # After 365 days, permanently delete the old, archived versions.
#     noncurrent_version_expiration {
#       noncurrent_days = 365
#     }
#   }
# }
