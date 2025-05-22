# Launch Template 생성
resource "aws_launch_template" "app_lt" {
  name_prefix   = "was-launch-template-"
  image_id      = "ami-05a7f3469a7653972"  # ✅ 여기 직접 지정

  instance_type = var.instance_type         # EC2 타입도 변수로 주입
  key_name      = var.key_name          # SSH 접근을 위한 키페어

  iam_instance_profile {
    name = var.iam_instance_profile_name    # EC2에 연결할 IAM Role
  }

  user_data = base64encode(var.user_data)       # 초기 부팅 시 실행할 스크립트

  vpc_security_group_ids = var.security_group_ids       # 보안 그룹 설정


  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "AppInstance"
    }
  }
}


# ----------------------------
##############################
# 1. Launch Template
##############################
# resource "aws_launch_template" "was_template" {
#   name_prefix   = "was-launch-template-"
#   image_id      = var.ami_id                         # 사용할 AMI ID
#   instance_type = "t3.micro"

#   iam_instance_profile {
#     name = var.instance_profile_name                 # EC2 인스턴스에 연결할 IAM 역할
#   }

#    {
#     associate_public_ip_address = false              # 퍼블릭 IP 비활성화 (프라이빗 서브넷)
#     security_groups             = [var.security_group_id]
#   }

#   user_data = base64encode(file("scripts/user_data.sh"))  # 초기 실행 스크립트
# }
