resource "aws_iam_role" "monitoring_ec2_sd_role" {
  name = "monitoring-ec2-sd-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "monitoring_ec2_sd_policy" {
  name = "monitoring-ec2-sd-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeTags"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.monitoring_ec2_sd_role.name
  policy_arn = aws_iam_policy.monitoring_ec2_sd_policy.arn
}

resource "aws_iam_instance_profile" "monitoring_instance_profile" {
  name = "monitoring-instance-profile"
  role = aws_iam_role.monitoring_ec2_sd_role.name
}

resource "aws_security_group" "monitoring_sg" {
  name        = "monitoring-sg"
  description = "Allow HTTP/Scouter/Grafana access"
  vpc_id      = var.vpc_id  # 사용 중인 VPC ID 입력

  # Prometheus 웹 UI
  ingress {
    description = "Allow HTTP access to Prometheus (9090)"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]  # 또는 ["0.0.0.0/0"] 테스트용, 보안 시 YOUR_IP로 제한
  }

  # Scouter Web UI
  ingress {
    description = "Allow HTTP access to Scouter UI (6180)"
    from_port   = 6180
    to_port     = 6180
    protocol    = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]  # 또는 ["0.0.0.0/0"]
  }

  # Scouter Agent 통신 포트
  ingress {
    description = "Allow agent communication (TCP 6100)"
    from_port   = 6100
    to_port     = 6100
    protocol    = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]  # 내부 VPC 통신용
  }

  ingress {
    description = "Allow agent communication (UDP 6100)"
    from_port   = 6100
    to_port     = 6100
    protocol    = "udp"
    cidr_blocks =  ["0.0.0.0/0"]  # 내부 VPC 통신용
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "monitoring-sg"
  }
}


resource "aws_instance" "ec2-monitoring-server" {
  ami                    = "ami-05a7f3469a7653972"
  instance_type          = "t3.micro"
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.monitoring_sg.id]

  key_name = "KoCo_testServer_key"

  iam_instance_profile = aws_iam_instance_profile.monitoring_instance_profile.name

  tags = {
    Name = "ec2-monitoring-server"
  }
}



# [WAS 인스턴스]
# 컨테이너 A (자바스프링 + java Agent)
# 컨테이너 B (Node Exporter)

# [모니터링 인스턴스]
# 컨테이너 A (스카우터 서버)
# 컨테이너 B (프로메테우스 서버)