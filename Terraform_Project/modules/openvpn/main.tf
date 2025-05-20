# openvpn 인스턴스 생성
resource "aws_instance" "openvpn" {
    ami                         = var.ami
    instance_type               = var.instance_type
    subnet_id                   = var.subnet_id
    vpc_security_group_ids      = var.vpc_security_group_ids
    associate_public_ip_address = var.associate_public_ip_address
    source_dest_check           = false
    key_name                    = var.key_name

    user_data = file("${path.module}/openvpn-setup.sh")

    tags = {
      Name = "koco_openvpn"
    }
}