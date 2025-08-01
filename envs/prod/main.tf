terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }

  backend "s3" {
    bucket         = "koo-blog-tfstate"
    key            = "prod.tfstate"
    region         = "ap-northeast-2"
    encrypt        = true
    dynamodb_table = "koo-blog-tfstate-lock"
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

provider "kubernetes" {
  host                   = module.eks.eks_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  token                  = module.eks.eks_cluster_auth.token
}

provider "helm" {
  kubernetes = {
    host                   = module.eks.eks_endpoint
    token                  = module.eks.eks_cluster_auth.token
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  }
}

resource "helm_release" "aws_load_balancer_controller" {
  name            = "aws-load-balancer-controller"
  chart           = "aws-load-balancer-controller"
  repository      = "https://aws.github.io/eks-charts"
  namespace       = "kube-system"
  force_update    = true
  replace         = true
  atomic          = true
  cleanup_on_fail = true

  values = [
    <<-EOT
    clusterName: ${module.eks.eks_name}
    serviceAccount:
      create: true
      name: aws-load-balancer-controller
      annotations:
        eks.amazonaws.com/role-arn: ${module.eks.ingress_controller_role_arn}
    region: ap-northeast-2
    vpcId: ${module.vpc.vpc_id}
    EOT
  ]
}

module "vpc" {
  source          = "../../modules/vpc"
  vpc_name        = local.vpc_name
  vpc_cidr        = local.vpc_cidr
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets
}

module "rds" {
  for_each = local.rds_instances
  source   = "../../modules/rds"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids

  identifier = each.key

  engine         = each.value.engine
  engine_version = each.value.engine_version
  instance_class = each.value.instance_class

  allocated_storage     = each.value.allocated_storage
  max_allocated_storage = each.value.max_allocated_storage
  storage_type          = each.value.storage_type
  storage_encrypted     = each.value.storage_encrypted

  db_name  = each.value.db_name
  username = each.value.username
  password = each.value.password

  publicly_accessible = each.value.publicly_accessible
  multi_az            = each.value.multi_az

  backup_retention_period      = each.value.backup_retention_period
  monitoring_interval          = each.value.monitoring_interval
  performance_insights_enabled = each.value.performance_insights_enabled
  deletion_protection          = each.value.deletion_protection
  skip_final_snapshot          = each.value.skip_final_snapshot
}

module "eks" {
  source                   = "../../modules/eks"
  eks_prefix               = local.eks_prefix
  kubernetes_version       = local.eks_kubernetes_version
  endpoint_private_access  = local.eks_endpoint_private_access
  endpoint_public_access   = local.eks_endpoint_public_access
  subnet_ids               = module.vpc.all_subnet_ids
  eks_node_groups          = local.eks_node_groups
  account_id               = local.account_id
  aws_lb_controller_policy = local.aws_lb_controller_policy
  aws_auth_map_users       = local.aws_auth_map_users
}
