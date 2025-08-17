resource "aws_iam_role" "eks_node_group" {
  name = "${var.env_prefix}-eks-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name      = "${var.env_prefix}-eks-node-group-role"
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "eks_node_group_policy_readonly" {
  role       = aws_iam_role.eks_node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eks_node_group_policy_cni" {
  role       = aws_iam_role.eks_node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_node_group_policy_worker" {
  role       = aws_iam_role.eks_node_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_eks_node_group" "main" {
  for_each = var.eks_node_groups

  cluster_name = aws_eks_cluster.main.name

  version = aws_eks_cluster.main.version

  node_group_name = "${var.env_prefix}-eks-node-group-${each.key}"
  node_role_arn   = aws_iam_role.eks_node_group.arn

  subnet_ids = var.node_group_subnet_ids

  capacity_type  = each.value.capacity_type
  instance_types = each.value.instance_types

  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
    min_size     = each.value.min_size
  }

  update_config {
    max_unavailable = each.value.max_unavailable
  }

  tags = {
    Name      = "${var.env_prefix}-eks-node-group-${each.key}"
    ManagedBy = "Terraform"
  }
}
