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
