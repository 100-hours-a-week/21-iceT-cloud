variable "app_name" {
  description = "CodeDeploy 애플리케이션 이름"
  type        = string
}

variable "deployment_group_name" {
  description = "CodeDeploy 배포 그룹 이름"
  type        = string
}

variable "service_role_arn" {
  description = "CodeDeploy 배포에 사용할 IAM 역할 ARN"
  type        = string
}

variable "autoscaling_groups" {
  description = "배포 대상으로 사용할 Auto Scaling Group 이름 목록"
  type        = list(string)
}

variable "alb_listener_https_arn" {
  description = "alb_listener_arn"
  type        = string
}

variable "alb_listener_test_https_arn" {
  description = "alb_listener_arn"
  type        = string
}

# variable "deployment_config_name" {
#   description = "배포 구성 이름 (예: CodeDeployDefault.OneAtATime)"
#   type        = string
#   default     = "CodeDeployDefault.OneAtATime"
# }

variable "auto_rollback_enabled" {
  description = "자동 롤백 활성화 여부"
  type        = bool
  default     = true
}

variable "auto_rollback_events" {
  description = "자동 롤백 시 동작할 이벤트 목록"
  type        = list(string)
  default     = ["DEPLOYMENT_FAILURE"]
}

variable "target_group_blue_name" {
  description = "blue 대상 그룹 이름"
  type = string
}


variable "target_group_green_name" {
  description = "green 대상 그룹 이름"
  type = string
}
