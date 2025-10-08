terraform {
  backend "s3" {
    # Replace this with the S3 bucket name from your backend setup.
    bucket = "REPLACE_WITH_YOUR_S3_BUCKET_NAME"

    # This is a unique path within the bucket for this specific project's state.
    # It's a best practice to organize state files by environment/project.
    key = "production/web-app/terraform.tfstate"

    # The AWS region where your S3 bucket was created.
    region = "us-east-1"

    # Ensures the state file is encrypted on the server side.
    encrypt = true
  }
}
