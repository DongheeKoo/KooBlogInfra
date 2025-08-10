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
}

module "vpc" {
  source          = "../../modules/vpc"
  vpc_name        = local.env_prefix
  vpc_cidr        = local.vpc_config.vpc.cidr
  public_subnets  = local.vpc_config.subnets.public
  private_subnets = local.vpc_config.subnets.private
}
