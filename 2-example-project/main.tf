provider "aws" {
  region = "us-east-1"
}

# This is a simple example resource to demonstrate that the remote state
# backend is working correctly. When you apply this configuration, Terraform
# will lock the state, create the instance, and then write the new state
# file back to your S3 bucket.
resource "aws_instance" "example" {
  # This AMI is for Amazon Linux 2 in the us-east-1 region.
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "Example-From-S3-Backend"
  }
}
