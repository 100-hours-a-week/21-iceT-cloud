resource "aws_security_group" "sg_openvpn" { # openvpn 보안 그룹
    name   = "sg_openvpn"
    vpc_id = var.vpc_id

    ingress { # 인바운드
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress { # 인바운드
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
      from_port = 1194
        to_port = 1194
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    ingress {
      from_port = 943
        to_port = 943
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
    }

    egress { # 아웃바운드
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}