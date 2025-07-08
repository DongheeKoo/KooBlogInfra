resource "aws_iam_role" "eks_node_group" {
  name = "${var.eks_prefix}-node-group-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name      = "${var.eks_prefix}-node-group-role"
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_group.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_group.name
}

resource "aws_iam_role_policy_attachment" "eks_ecr_readonly_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_group.name
}

resource "aws_eks_node_group" "eks_node_group" {
  for_each = var.eks_node_groups

  cluster_name = aws_eks_cluster.eks.name

  version = aws_eks_cluster.eks.version

  node_group_name = "${var.eks_prefix}-node-group-${each.key}"
  node_role_arn   = aws_iam_role.eks_node_group.arn

  subnet_ids = each.value.subnet_ids

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

  depends_on = [
    aws_iam_role.eks_node_group,
    aws_eks_cluster.eks
  ]

  tags = {
    Name      = "${var.eks_prefix}-node-group"
    ManagedBy = "Terraform"
  }
}
