terraform {
  backend "s3" {
    bucket = "terra-bucket-23"
    key    = "megaProject/terraform.tfstate"
    region = "us-east-1"
  }
}