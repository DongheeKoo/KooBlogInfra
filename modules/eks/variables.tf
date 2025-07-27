variable "eks_prefix" {
  type        = string
  description = "EKS 클러스터 이름 접두사"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes 버전"
}

variable "endpoint_private_access" {
  type        = bool
  description = "EKS 클러스터 Endpoint Private 접근 여부"
}

variable "endpoint_public_access" {
  type        = bool
  description = "EKS 클러스터 Endpoint Public 접근 여부"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet ID 목록"
}

variable "eks_node_groups" {
  type        = map(any)
  description = "EKS Node Group 목록"
}

variable "account_id" {
  type        = string
  description = "AWS 계정 ID"
}

variable "aws_lb_controller_policy" {
  type        = string
  description = "AWS LB Controller 정책"
}

variable "aws_auth_map_users" {
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  description = "aws-auth ConfigMap의 mapUsers 설정"
}
