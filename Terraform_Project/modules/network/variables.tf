variable "vpc_cidr" {
  description = "VPC 전체 IP 범위"
  type        = string
  default     = "10.1.0.0/16"
}

variable "public_subnets" {
  description = "퍼블릭 서브넷 목록. 각 서브넷은 cidr과 availability_zone 값을 가진 객체입니다."
  type = list(object({
    cidr = string
    az   = string
  }))
  default = [
    { cidr = "10.1.1.0/24", az = "ap-northeast-2a" },
    { cidr = "10.1.2.0/24", az = "ap-northeast-2c" }
  ]
}

variable "private_app_subnets" {
  description = "어플리케이션 인스턴스용 프라이빗 서브넷 목록 (NAT 연결)"
  type = list(object({
    cidr = string
    az   = string
  }))
  default = [
    { cidr = "10.1.3.0/24", az = "ap-northeast-2a" },
    { cidr = "10.1.5.0/24", az = "ap-northeast-2c" }
  ]
}

variable "private_db_subnets" {
  description = "데이터베이스 인스턴스용 프라이빗 서브넷 목록 (NAT 미연결)"
  type = list(object({
    cidr = string
    az   = string
  }))
  default = [
    { cidr = "10.1.4.0/24", az = "ap-northeast-2a" },
    { cidr = "10.1.6.0/24", az = "ap-northeast-2c" }
  ]
}
