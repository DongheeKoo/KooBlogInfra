variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "DB 서브넷 그룹 ID"
}

variable "identifier" {
  type        = string
  description = "RDS 인스턴스 이름"
}

variable "engine" {
  type        = string
  description = "RDS 엔진"
}

variable "engine_version" {
  type        = string
  description = "RDS 엔진 버전"
}

variable "instance_class" {
  type        = string
  description = "RDS 인스턴스 클래스"
}

variable "allocated_storage" {
  type        = number
  description = "DB 인스턴스 저장소 용량"
}

variable "max_allocated_storage" {
  type        = number
  description = "DB 인스턴스 최대 저장소 용량"
}

variable "storage_type" {
  type        = string
  description = "DB 인스턴스 저장소 타입"
}

variable "storage_encrypted" {
  type        = bool
  description = "DB 인스턴스 저장소 암호화 여부"
}

variable "db_name" {
  type        = string
  description = "DB 이름"
}

variable "username" {
  type        = string
  description = "DB 사용자 이름"
}

variable "password" {
  type        = string
  description = "DB 사용자 비밀번호"
}

variable "publicly_accessible" {
  type        = bool
  description = "DB 인스턴스 공개 여부"
}

variable "multi_az" {
  type        = bool
  description = "DB 인스턴스 다중 가용 영역 여부"
}

variable "backup_retention_period" {
  type        = number
  description = "DB 백업 보존 기간"
}

variable "monitoring_interval" {
  type        = number
  description = "DB 모니터링 간격"
}

variable "performance_insights_enabled" {
  type        = bool
  description = "DB 성능 인사이트 활성화 여부"
}

variable "deletion_protection" {
  type        = bool
  description = "DB 인스턴스 삭제 보호 여부"
}

variable "skip_final_snapshot" {
  type        = bool
  description = "DB 인스턴스 삭제 시 스냅샷 생성 여부"
}
