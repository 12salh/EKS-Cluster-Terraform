terraform {
  backend "s3" {
    bucket         = "nti-terraform-states-1"
    key            = "eks/nonprod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "nti-terraform-locks"
    encrypt        = true
  }
}