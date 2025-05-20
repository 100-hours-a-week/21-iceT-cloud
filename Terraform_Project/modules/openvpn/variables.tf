variable "ami" {
  description = "OpenVPN Access Server 인스턴스에 사용할 AMI ID"
  type        = string
  default     = "ami-09a093fa2e3bfca5a" 
}

variable "instance_type" {
  description = "EC2 인스턴스 타입"
  type        = string
  default     = "t3.small"
}

variable "subnet_id" {
  description = "OpenVPN 인스턴스를 배포할 서브넷 ID"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "인스턴스에 적용할 보안 그룹 ID 목록"
  type        = list(string)
}

variable "associate_public_ip_address" {
  description = "퍼블릭 IP 자동 할당 여부"
  type        = bool
  default     = true
}

variable "key_name" {
  description = "key pair 이름"
  type = string
  default = "KoCo_testServer_key"  
}