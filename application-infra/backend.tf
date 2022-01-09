## Setup S3 backend for TF

terraform {
  backend "s3" {
    bucket = "si-index-application-infra"
    key    = "application.tfstate"
    region = "eu-west-2"
  }
}