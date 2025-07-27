data "kubernetes_config_map_v1" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  depends_on = [
    aws_eks_cluster.eks,
    aws_eks_node_group.eks_node_group
  ]
}

resource "kubernetes_config_map_v1" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = merge(
    data.kubernetes_config_map_v1.aws_auth.data,
    {
      mapUsers = yamlencode(var.aws_auth_map_users)
    }
  )

  depends_on = [
    data.kubernetes_config_map_v1.aws_auth
  ]

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
      metadata[0].annotations
    ]
  }
}
