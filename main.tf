provider "aws" {
  region = "eu-west-2"
}

module "eks_fargate" {
  source  = "./terraform-aws-eks/examples/fargate"
  cluster_name = "${var.environment}-${var.cluster_name}"
  region = "eu-west-2"
}








