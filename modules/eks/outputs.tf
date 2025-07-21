output "eks_endpoint" {
  description = "EKS 클러스터의 엔드포인트"
  value       = aws_eks_cluster.eks.endpoint
}

output "cluster_ca_certificate" {
  description = "EKS 클러스터의 CA 인증서"
  value       = aws_eks_cluster.eks.certificate_authority[0].data
}

output "eks_name" {
  description = "EKS 클러스터의 이름"
  value       = aws_eks_cluster.eks.name
}

output "eks_cluster_auth" {
  description = "EKS 클러스터의 인증 정보"
  value       = data.aws_eks_cluster_auth.eks
}

output "ingress_controller_role_arn" {
  description = "Ingress Controller가 사용할 IAM 역할 ARN"
  value       = aws_iam_role.aws_lb_controller.arn
}
