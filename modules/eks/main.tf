resource "aws_iam_role" "eks_cluster" {
  name = "${var.env_prefix}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

  depends_on = [aws_iam_role.eks_cluster]
}


resource "aws_eks_cluster" "main" {
  name     = "${var.env_prefix}-eks"
  role_arn = aws_iam_role.eks_cluster.arn

  version = var.eks_version

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  vpc_config {
    subnet_ids              = var.cluster_subnet_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
  }

  tags = {
    Name      = "${var.env_prefix}-eks"
    ManagedBy = "Terraform"
  }
}
