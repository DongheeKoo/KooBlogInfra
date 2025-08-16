terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

locals {
  env_prefix = "koo-blog"

  vpc_config = yamldecode(file("${path.module}/values/vpc.yaml"))
  eks_config = yamldecode(file("${path.module}/values/eks.yaml"))

  vpc_subnet_map = {
    public  = module.vpc.public_subnet_ids
    private = module.vpc.private_subnet_ids
  }

  eks_subnet_ids = flatten([
    for subnet_type, indices in local.eks_config.cluster.subnets.control_plane : [
      for index in indices : local.vpc_subnet_map[subnet_type][index]
    ]
  ])
}

module "vpc" {
  source          = "../../modules/vpc"
  vpc_name        = local.env_prefix
  vpc_cidr        = local.vpc_config.vpc.cidr
  public_subnets  = local.vpc_config.subnets.public
  private_subnets = local.vpc_config.subnets.private
}

module "eks" {
  source = "../../modules/eks"

  env_prefix              = local.env_prefix
  eks_version             = local.eks_config.cluster.eks_version
  endpoint_private_access = local.eks_config.cluster.endpoint_private_access
  endpoint_public_access  = local.eks_config.cluster.endpoint_public_access
  subnet_ids              = module.vpc.private_subnet_ids
}
