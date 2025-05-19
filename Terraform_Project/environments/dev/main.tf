module "network" {
  source = "../../modules/network"

  vpc_cidr = "10.1.0.0/16"
  
  public_subnets = [
    { cidr = "10.1.1.0/24", az = "ap-northeast-2a" },
    { cidr = "10.1.2.0/24", az = "ap-northeast-2c" }
  ]
  
  private_app_subnets = [
    { cidr = "10.1.3.0/24", az = "ap-northeast-2a" },
    { cidr = "10.1.5.0/24", az = "ap-northeast-2c" }
  ]
  
  private_db_subnets = [
    { cidr = "10.1.4.0/24", az = "ap-northeast-2a" },
    { cidr = "10.1.6.0/24", az = "ap-northeast-2c" }
  ]
}

# module "asg" {
#   source = "../modules/asg"

#   environment           = "dev"
#   asg_name              = "app-asg-dev"
#   vpc_zone_identifier   = module.network.private_app_subnet_ids
#   launch_template_id    = module.ec2.launch_template_id
#   launch_template_version = "$Latest"
#   desired_capacity      = 2
#   min_size              = 2
#   max_size              = 4
#   target_group_arns     = [module.alb.target_group_arn] // 아직 alb 모듈 생성전 생성 후 추가
#   health_check_type         = "EC2"
#   health_check_grace_period = 300
#   instance_tag_name     = "app-instance"

#   depends_on = [
#     module.network,  // network 모듈이 완료된 후 실행
#     module.alb,      // alb 모듈이 완료된 후 실행
#     module.ec2       // ec2 모듈이 완료된 후 실행
#   ]
# }


