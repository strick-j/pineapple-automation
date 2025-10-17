terraform {
  backend "s3" {
    bucket         = "pineapple.dev"
    key            = "terraform/terraform.tfstate"
    profile        = "AdministratorAccess-475601244925"
    region         = "us-east-2"
    dynamodb_table = "pineapple-terraform-lock-table"
    encrypt        = true
  }
}