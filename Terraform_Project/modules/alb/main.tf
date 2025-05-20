# ALB 생성
resource "aws_lb" "this" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  tags = {
    Name        = var.alb_name
  }
}

# ALB 대상 그룹 생성 (HTTP 포트 80)
resource "aws_lb_target_group" "blue" {
  name     = "${var.target_group_name}-blue-tg"
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = {
    Name   = "${var.target_group_name}-blue-tg"
  }
}

resource "aws_lb_target_group" "green" {
  name     = "${var.target_group_name}-green-tg"
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = {
    Name   = "${var.target_group_name}-green-tg"
  }
}

# ALB Listener 생성
# 1. HTTP → HTTPS 리디렉션
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      protocol    = "HTTPS"
      port        = "443"
      status_code = "HTTP_301"
    }
  }
  tags = {
    Name = var.listener_http_name
  }
}

# 2. HTTPS 리스너 → 대상 그룹으로 요청 전달
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn  # 기본은 Blue로
  }

  tags = {
    Name = var.listener_https_name
  }
}
