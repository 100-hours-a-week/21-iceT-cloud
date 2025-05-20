resource "aws_security_group" "sg_openvpn" { # openvpn 보안 그룹
    name   = "sg_openvpn"
    vpc_id = var.vpc_id

    ingress { 
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress { 
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
      from_port = 1194
        to_port = 1194
        protocol = "udp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
      from_port = 943
        to_port = 943
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress { 
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "sg_alb" { # alb 보안 그룹
  name   = "sg_alb"
  description = "Allow HTTP and HTTPS inbound traffic to ALB"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"] 
    description = ""
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = ""
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}