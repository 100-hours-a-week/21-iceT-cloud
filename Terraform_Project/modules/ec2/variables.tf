variable "instance_type" {
  description = "EC2 인스턴스 타입 (예: t3.micro)"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH 키 페어 이름"
  type        = string
  default     = "KoCo_testServer_key"
}

variable "iam_instance_profile_name" {
  description = "EC2 인스턴스에 연결할 IAM 인스턴스 프로파일 이름"
  type        = string
}

variable "security_group_ids" {
  description = "EC2 인스턴스에 적용할 보안 그룹 ID 목록"
  type        = list(string)
}

variable "user_data" {
  description = "EC2 인스턴스 부팅 시 실행할 user_data 스크립트 (base64 인코딩 필요 없음)"
  type        = string
  default     = <<-EOF
    #!/bin/bash
    set -e

    #-------------------------------
    # 시스템 패키지 업데이트
    #-------------------------------
    apt-get update -y
    apt-get upgrade -y

    #-------------------------------
    # CodeDeploy 에이전트 설치
    #-------------------------------
    apt-get install -y ruby wget
    cd /home/ubuntu
    wget https://aws-codedeploy-ap-northeast-2.s3.amazonaws.com/latest/install
    chmod +x ./install
    ./install auto
    systemctl start codedeploy-agent
    systemctl enable codedeploy-agent

    #-------------------------------
    # Docker 설치 및 설정
    #-------------------------------
    apt-get install -y \
      ca-certificates \
      curl \
      gnupg \
      lsb-release

    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
      | tee /etc/apt/sources.list.d/docker.list > /dev/null

    apt-get update -y
    apt-get install -y docker-ce docker-ce-cli containerd.io

    systemctl start docker
    systemctl enable docker
    usermod -aG docker ubuntu

    #-------------------------------
    # Docker Compose 설치
    #-------------------------------
    curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" \
      -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
  EOF
}
