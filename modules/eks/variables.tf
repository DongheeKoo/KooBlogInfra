variable "env_prefix" {
  type        = string
  description = "환경 Prefix"
}

variable "eks_version" {
  type        = string
  description = "EKS 버전"
}

variable "cluster_subnet_ids" {
  type        = list(string)
  description = "EKS 클러스터가 Pod을 생성할 서브넷 ID 목록"
}

variable "endpoint_private_access" {
  type        = bool
  description = "Endpoint private access 활성화 여부"
}

variable "endpoint_public_access" {
  type        = bool
  description = "Endpoint public access 활성화 여부"
}

variable "eks_node_groups" {
  type        = map(any)
  description = "EKS 노드 그룹 목록"
}

variable "node_group_subnet_ids" {
  type        = list(string)
  description = "노드 그룹이 노드를 생성할 서브넷 ID 목록"
}
