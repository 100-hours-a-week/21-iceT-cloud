resource "aws_iam_role" "ec2_s3_access" {
  name = "ec2-s3-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "s3_access_policy" {
  name   = "S3ReadAccess"
  role   = aws_iam_role.ec2_s3_access.name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = ["s3:GetObject"],
      Resource = "arn:aws:s3:::koco-db-backup/*"
    }]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-s3-access-profile"
  role = aws_iam_role.ec2_s3_access.name
}




resource "aws_instance" "mysql_server" {
  ami                    = "ami-05a7f3469a7653972"
  instance_type          = "t3.micro"
  subnet_id              = var.subnet_private_id
  private_ip             = "10.1.4.100" # 고정 프라이빗 IP 지정
  vpc_security_group_ids = [var.security_group_db_sg_id]
  key_name               = var.key_pair_name
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = base64encode(<<-EOF
    #!/bin/bash

    # 전체 로그 파일로 저장 (선택)
    exec > /var/log/user-data-output.log 2>&1
    set -e

    # 네트워크 안정 대기
    echo "⏳ Waiting for network..."
    sleep 15

    # 패키지 업데이트 및 필수 패키지 설치
    sudo apt update
    sudo apt install -y openjdk-21-jdk mysql-server awscli

    # MySQL 서비스 시작 및 자동 시작 등록
    sudo systemctl start mysql
    sudo systemctl enable mysql

    # MySQL 기본 사용자 및 DB 설정
    sudo mysql --user=root <<EOSQL
    ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'koco';
    CREATE DATABASE IF NOT EXISTS koco;
    CREATE USER IF NOT EXISTS 'was_user'@'10.1.%' IDENTIFIED BY 'koco';
    GRANT ALL PRIVILEGES ON koco.* TO 'was_user'@'10.1.%';
    FLUSH PRIVILEGES;
    EOSQL

    # S3에서 최신 백업 SQL 파일 다운로드 및 복원
    TMP_DIR="/tmp/koco-db"
    sudo mkdir -p \$TMP_DIR
    cd \$TMP_DIR

    # 최신 백업 파일명을 AWS CLI 파이프라인으로 추출하여 변수에 할당
    LATEST_BACKUP=$(sudo aws s3 ls s3://koco-db-backup/ --recursive \
      | awk '{ print $1" "$2" "$4 }' \
      | grep '\.sql$' \
      | sort -k1,2 \
      | tail -n1 \
      | awk '{ print $3 }')

    # 파일 다운로드
    sudo aws s3 cp s3://koco-db-backup/\$LATEST_BACKUP .

    # DB 복원
    sudo mysql -u root -pkoco koco < \$LATEST_BACKUP
  EOF
  )


  tags = {
    Name = "mysql-db-server"
  }
}