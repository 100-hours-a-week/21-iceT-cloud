variable "vpc_id" {
  description = "VPC 전체 IP 범위"
  type        = string
}

variable "private_subnet_id" {
  description = "인스턴스가 생성될 서브넷"
  type        = string
}