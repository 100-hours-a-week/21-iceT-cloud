resource "aws_autoscaling_group" "this" {
  name                = var.asg_name
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = var.vpc_zone_identifier     #  인스턴스가 자동 분산 배치됨

  launch_template {
    id      = var.launch_template_id
    version = var.launch_template_version
  }


  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period



  tag {
    key                 = "Name"
    value               = var.instance_tag_name
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true   # 배포 시 무중단 되도록 기존 인스턴스 삭제 전 새로 생성
  }
}
