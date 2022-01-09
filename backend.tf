## Setup S3 backend for TF

terraform {
  backend "s3" {
    bucket = "s-index-senapt-eks-cluster"
    key    = "product.tfstate"
    region = "eu-west-2"
  }
}