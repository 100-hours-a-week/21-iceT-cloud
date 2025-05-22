variable "codedeploy_role_name" {
  description = "CodeDeploy IAM 역할 이름"
  type        = string
  default     = "CodeDeployServiceRole"
}

variable "ec2_role_name" {
  description = "EC2 인스턴스용 IAM 역할 이름"
  type        = string
  default     = "MyEC2Role"
}

variable "ec2_instance_profile_name" {
  description = "EC2 인스턴스 프로파일 이름"
  type        = string
  default     = "MyEC2InstanceProfile"
}
