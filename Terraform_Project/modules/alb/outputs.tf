output "alb_arn" {
  description = "생성된 ALB의 ARN"
  value       = aws_lb.this.arn
}

output "alb_dns_name" {
  description = "생성된 ALB의 DNS 이름"
  value       = aws_lb.this.dns_name
}

output "target_group_blue_arn" {
  description = "생성된 ALB Blue 대상 그룹의 ARN"
  value       = aws_lb_target_group.blue.arn
}

output "target_group_blue_name" {
  description = "생성된 ALB Blue 대상 그룹의 name"
  value       = aws_lb_target_group.blue.name
}

output "target_group_green_arn" {
  description = "생성된 ALB Green 대상 그룹의 ARN"
  value       = aws_lb_target_group.green.arn
}

output "target_group_green_name" {
  description = "생성된 ALB Green 대상 그룹의 name"
  value       = aws_lb_target_group.green.name
}

output "alb_listener_https_arn" {
  description = "생성된 ALB 리스너의 ARN"
  value       = aws_lb_listener.https.arn
}

output "alb_listener_test_https_arn" {
  description = "생성된 ALB 리스너의 ARN"
  value       = aws_lb_listener.test_https.arn
}
