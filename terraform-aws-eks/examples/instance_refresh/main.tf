provider "aws" {
  region = local.region
}

locals {
  name            = "instance_refresh-${random_string.suffix.result}"
  cluster_version = "1.20"
  region          = "eu-west-1"
}

################################################################################
# EKS Module
################################################################################

# Based on the official aws-node-termination-handler setup guide at https://github.com/aws/aws-node-termination-handler#infrastructure-setup

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "aws_node_termination_handler" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeInstances",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeTags",
    ]
    resources = [
      "*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "autoscaling:CompleteLifecycleAction",
    ]
    resources = module.eks.workers_asg_arns
  }
  statement {
    effect = "Allow"
    actions = [
      "sqs:DeleteMessage",
      "sqs:ReceiveMessage"
    ]
    resources = [
      module.aws_node_termination_handler_sqs.sqs_queue_arn
    ]
  }
}

resource "aws_iam_policy" "aws_node_termination_handler" {
  name   = "${local.name}-aws-node-termination-handler"
  policy = data.aws_iam_policy_document.aws_node_termination_handler.json
}

data "aws_region" "current" {}

data "aws_iam_policy_document" "aws_node_termination_handler_events" {
  statement {
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "events.amazonaws.com",
        "sqs.amazonaws.com",
      ]
    }
    actions = [
      "sqs:SendMessage",
    ]
    resources = [
      "arn:aws:sqs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${local.name}",
    ]
  }
}

module "aws_node_termination_handler_sqs" {
  source                    = "terraform-aws-modules/sqs/aws"
  version                   = "~> 3.0.0"
  name                      = local.name
  message_retention_seconds = 300
  policy                    = data.aws_iam_policy_document.aws_node_termination_handler_events.json
}

resource "aws_cloudwatch_event_rule" "aws_node_termination_handler_asg" {
  name        = "${local.name}-asg-termination"
  description = "Node termination event rule"
  event_pattern = jsonencode(
    {
      "source" : [
        "aws.autoscaling"
      ],
      "detail-type" : [
        "EC2 Instance-terminate Lifecycle Action"
      ]
      "resources" : module.eks.workers_asg_arns
    }
  )
}

resource "aws_cloudwatch_event_target" "aws_node_termination_handler_asg" {
  target_id = "${local.name}-asg-termination"
  rule      = aws_cloudwatch_event_rule.aws_node_termination_handler_asg.name
  arn       = module.aws_node_termination_handler_sqs.sqs_queue_arn
}

resource "aws_cloudwatch_event_rule" "aws_node_termination_handler_spot" {
  name        = "${local.name}-spot-termination"
  description = "Node termination event rule"
  event_pattern = jsonencode(
    {
      "source" : [
        "aws.ec2"
      ],
      "detail-type" : [
        "EC2 Spot Instance Interruption Warning"
      ]
      "resources" : module.eks.workers_asg_arns
    }
  )
}

resource "aws_cloudwatch_event_target" "aws_node_termination_handler_spot" {
  target_id = "${local.name}-spot-termination"
  rule      = aws_cloudwatch_event_rule.aws_node_termination_handler_spot.name
  arn       = module.aws_node_termination_handler_sqs.sqs_queue_arn
}

module "aws_node_termination_handler_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "4.1.0"
  create_role                   = true
  role_description              = "IRSA role for ANTH, cluster ${local.name}"
  role_name_prefix              = local.name
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.aws_node_termination_handler.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:aws-node-termination-handler"]
}

resource "helm_release" "aws_node_termination_handler" {
  depends_on = [
    module.eks
  ]

  name             = "aws-node-termination-handler"
  namespace        = "kube-system"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-node-termination-handler"
  version          = "0.15.0"
  create_namespace = true

  set {
    name  = "awsRegion"
    value = data.aws_region.current.name
  }
  set {
    name  = "serviceAccount.name"
    value = "aws-node-termination-handler"
  }
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.aws_node_termination_handler_role.iam_role_arn
    type  = "string"
  }
  set {
    name  = "enableSqsTerminationDraining"
    value = "true"
  }
  set {
    name  = "enableSpotInterruptionDraining"
    value = "true"
  }
  set {
    name  = "queueURL"
    value = module.aws_node_termination_handler_sqs.sqs_queue_id
  }
  set {
    name  = "logLevel"
    value = "debug"
  }
}

# Creating the lifecycle-hook outside of the ASG resource's `initial_lifecycle_hook`
# ensures that node termination does not require the lifecycle action to be completed,
# and thus allows the ASG to be destroyed cleanly.
resource "aws_autoscaling_lifecycle_hook" "aws_node_termination_handler" {
  count                  = length(module.eks.workers_asg_names)
  name                   = "aws-node-termination-handler"
  autoscaling_group_name = module.eks.workers_asg_names[count.index]
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"
  heartbeat_timeout      = 300
  default_result         = "CONTINUE"
}

module "eks" {
  source = "../.."

  cluster_name    = local.name
  cluster_version = local.cluster_version

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.private_subnets

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  enable_irsa = true
  worker_groups_launch_template = [
    {
      name                                 = "refresh"
      asg_max_size                         = 2
      asg_desired_capacity                 = 2
      instance_refresh_enabled             = true
      instance_refresh_instance_warmup     = 60
      public_ip                            = true
      metadata_http_put_response_hop_limit = 3
      update_default_version               = true
      instance_refresh_triggers            = ["tag"]
      tags = [
        {
          key                 = "aws-node-termination-handler/managed"
          value               = ""
          propagate_at_launch = true
        },
        {
          key                 = "foo"
          value               = "buzz"
          propagate_at_launch = true
        }
      ]
    }
  ]

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-eks"
    GithubOrg  = "terraform-aws-modules"
  }
}

################################################################################
# Kubernetes provider configuration
################################################################################

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

################################################################################
# Supporting Resources
################################################################################

data "aws_availability_zones" "available" {
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name                 = local.name
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/elb"              = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.name}" = "shared"
    "kubernetes.io/role/internal-elb"     = "1"
  }

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-eks"
    GithubOrg  = "terraform-aws-modules"
  }
}
