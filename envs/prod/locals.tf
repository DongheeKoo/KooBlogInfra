locals {

  ### VPC ###

  vpc_name = "koo-blog"
  vpc_cidr = "10.1.0.0/16"
  public_subnet = {
    cidr_block        = "10.1.0.0/18"
    availability_zone = "ap-northeast-2a"
  }
  private_subnets = {
    "private-subnet-1" = {
      cidr_block        = "10.1.64.0/18"
      availability_zone = "ap-northeast-2a"
    }
    "private-subnet-2" = {
      cidr_block        = "10.1.128.0/18"
      availability_zone = "ap-northeast-2b"
    }
  }

  ### RDS ###

  rds_instances = {
    "koo-blog" = {
      engine         = "postgres"
      engine_version = "16.8"
      instance_class = "db.t3.micro"

      allocated_storage     = 20
      max_allocated_storage = 20
      storage_type          = "gp2"
      storage_encrypted     = false

      db_name  = "main"
      username = var.koo_blog_username
      password = var.koo_blog_password

      publicly_accessible = false
      multi_az            = false

      backup_retention_period      = 0
      monitoring_interval          = 0
      performance_insights_enabled = false
      deletion_protection          = false
      skip_final_snapshot          = true
    }
  }

  ### EKS ###
  eks_prefix                  = "koo-blog"
  eks_kubernetes_version      = "1.32"
  eks_endpoint_private_access = false
  eks_endpoint_public_access  = true

  ### EKS Node Group ###
  eks_node_groups = {
    "first" = {
      capacity_type   = "ON_DEMAND"
      instance_types  = ["t3.micro"]
      desired_size    = 1
      max_size        = 1
      min_size        = 1
      max_unavailable = 1
      subnet_ids      = module.vpc.private_subnet_ids
    }
  }
}
