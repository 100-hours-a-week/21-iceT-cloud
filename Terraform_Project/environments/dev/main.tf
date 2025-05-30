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

module "s3_static_site" {
  source              = "../../modules/s3_static_site"
  cloudfront_oai_arn  = module.cdn.cloudfront_oai_arn
}

module "cdn" {
  source         = "../../modules/cdn"
  s3_bucket_name = module.s3_static_site.s3_bucket_name
  alb_dns_name = module.alb.alb_dns_name
}


module "ecr" {
  source           = "../../modules/ecr"
  repository_name  = "app-repo"
  tags = {
    Name        = "App Repo"
    Environment = "Production"
  }
}

module "iam" {
  source = "../../modules/iam"

  # 필요시 변수 값을 오버라이드할 수 있습니다.
  codedeploy_role_name       = "MyCodeDeployRole"
  ec2_role_name              = "MyEC2Role"
  ec2_instance_profile_name  = "MyEC2InstanceProfile"
}


module "security_groups" {
  source = "../../modules/security_groups"
  vpc_id = module.network.vpc_id
}

module "codedeploy" {
  source                = "../../modules/codedeploy"
  app_name              = "was-deploy-app"
  deployment_group_name = "was-deploy-group"
  service_role_arn      = module.iam.codedeploy_role_arn
  target_group_blue_name = module.alb.target_group_blue_name
  target_group_green_name = module.alb.target_group_green_name
  alb_listener_arn       = module.alb.listener_arn
  autoscaling_groups    = [module.asg.asg_name]

  depends_on = [
    module.iam,  // iam 모듈이 완료된 후 실행
    module.alb,      // alb 모듈이 완료된 후 실행
    module.asg       // asg 모듈이 완료된 후 실행
  ]
}

module "ec2" {
  source = "../../modules/ec2"

  instance_type              = "t3.micro"
  key_name                   = "KoCo_testServer_key"
  iam_instance_profile_name  = module.iam.ec2_instance_profile_name
  security_group_ids         = [module.security_groups.app_sg_id]
  # user_data는 기본값을 사용하거나 별도로 수정 가능
}


module "asg" {
  source = "../../modules/asg"

  environment           = "dev"
  asg_name              = "app-asg-dev"
  vpc_zone_identifier   = module.network.private_app_subnet_ids
  launch_template_id    = module.ec2.launch_template_id
  launch_template_version = "$Latest"
  desired_capacity      = 1
  min_size              = 1
  max_size              = 1

  health_check_type         = "EC2"
  health_check_grace_period = 300
  instance_tag_name     = "app-instance"

  depends_on = [
    module.network,  // network 모듈이 완료된 후 실행
    module.alb,      // alb 모듈이 완료된 후 실행
    module.ec2       // ec2 모듈이 완료된 후 실행
  ]

}

module "alb" {
  source              = "../../modules/alb"
  environment         = "dev"
  alb_name            = "app-alb"
  subnet_ids          = module.network.public_subnet_ids  # 네트워크 모듈의 출력값 사용 가능
  security_group_ids  = [module.security_groups.alb_sg_id]                   # ALB 전용 보안 그룹
  vpc_id              = module.network.vpc_id                                 # 네트워크 모듈의 VPC ID 사용
  # 나머지 변수들은 기본값 사용 (필요시 tfvars 또는 직접 값 지정)
}


module "openvpn" {
  source = "../../modules/openvpn"
  subnet_id               = module.network.public_subnet_ids[0]
  vpc_security_group_ids  = [module.security_groups.openvpn_sg_id]
}

module "monitoring-ec2" {
  source = "../../modules/monitoring-ec2"
  vpc_id = module.network.vpc_id
  private_subnet_id = module.network.private_app_subnet_ids[0]
}