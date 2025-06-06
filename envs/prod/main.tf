terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
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

module "vpc" {
  source         = "../../modules/vpc"
  vpc_name       = local.vpc_name
  vpc_cidr       = local.vpc_cidr
  public_subnet  = local.public_subnet
  private_subnet = local.private_subnet
}
