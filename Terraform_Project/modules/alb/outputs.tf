output "alb_dns_name"{ #실제 alb 주소
    value = aws_lb.this.dns_name
}