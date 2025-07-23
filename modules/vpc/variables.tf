variable "vpc_name" {
  type        = string
  description = "VPC 이름"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "public_subnets" {
  type        = map(map(string))
  description = "퍼블릭 서브넷 설정 정보"
}

variable "private_subnets" {
  type        = map(map(string))
  description = "프라이빗 서브넷 설정 정보"
}
