variable "alb_name" {
  description = "ALB 이름"
  type        = string
  default     = "koco-app-alb"
}

variable "subnet_ids" {
  description = "ALB를 배포할 퍼블릭 서브넷 ID 목록"
  type        = list(string)
}

variable "security_group_ids" {
  description = "ALB에 적용할 보안 그룹 ID 목록"
  type        = list(string)
}

variable "vpc_id" {
  description = "ALB 대상 그룹 생성을 위한 VPC ID"
  type        = string
}

variable "target_group_name" {
  description = "ALB 대상 그룹 이름"
  type        = string
  default     = "koco-app"
}

variable "target_group_port" {
  description = "대상 그룹 포트"
  type        = number
  default     = 80
}

variable "target_group_protocol" {
  description = "대상 그룹 프로토콜"
  type        = string
  default     = "HTTP"
}

variable "health_check_path" {
  description = "헬스 체크 경로"
  type        = string
  default     = "/health"
}

variable "health_check_protocol" {
  description = "헬스 체크 프로토콜"
  type        = string
  default     = "HTTP"
}

variable "health_check_matcher" {
  description = "헬스 체크 응답 매처"
  type        = string
  default     = "200"
}

variable "listener_port" {
  description = "ALB 리스너 포트"
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "ALB 리스너 프로토콜"
  type        = string
  default     = "HTTP"
}

variable "certificate_arn" { # 값 넣어 주어야 함
  description = "Certificate ARN for HTTPS"
  type        = string
}

variable "listener_http_name" {
  description = "ALB http 리스너 이름"
  type        = string
  default     = "koco-app-listener-http"
}

variable "listener_https_name" {
  description = "ALB https 리스너 이름"
  type        = string
  default     = "koco-app-listener-https"
}