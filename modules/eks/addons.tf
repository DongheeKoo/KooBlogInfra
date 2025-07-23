data "tls_certificate" "eks" {
  url = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = data.tls_certificate.eks.url

  tags = {
    Name      = "${var.eks_prefix}-oidc-k8s"
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_role" "aws_lb_controller" {
  name               = "${var.eks_prefix}-aws-lb-controller-role"
  assume_role_policy = local.aws_lb_controller_assume_role_policy

  tags = {
    Name      = "${var.eks_prefix}-aws-lb-controller-role"
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "aws_lb_controller_policy" {
  role       = aws_iam_role.aws_lb_controller.name
  policy_arn = var.aws_lb_controller_policy
}

locals {

  aws_lb_controller_assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          "Federated" : "arn:aws:iam::${var.account_id}:oidc-provider/${trimprefix(aws_iam_openid_connect_provider.eks.url, "https://")}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${trimprefix(aws_iam_openid_connect_provider.eks.url, "https://")}:aud" : "sts.amazonaws.com"
            "${trimprefix(aws_iam_openid_connect_provider.eks.url, "https://")}:sub" : "system:serviceaccount:kube-system:aws-load-balancer-controller"
          }
        }
      }
    ]
  })
}
