####################################
# 이미지 저장 버킷 생성 코드로 dev/main.tf의 모듈이 실행되지 않고, 
# 21-iceT-cloud/Terraform_Project/environments/s3 폴더에서 개별적으로 실행된다
# 즉 dev/main.tf을 terraform destroy해도 삭제되지 않음
####################################

resource "aws_s3_bucket" "image" {
  bucket = var.bucket_name
  force_destroy = false     # 버킷 비우기 없이 삭제 방지

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "image" {
  bucket = aws_s3_bucket.image.id

  block_public_acls       = true
  block_public_policy     = false  # 버킷 정책은 허용해야 하므로 false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "image" {
  bucket = aws_s3_bucket.image.id
  depends_on = [aws_s3_bucket_public_access_block.image]  # 퍼블릭 설정 먼저 적용됨을 보장

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowPublicReadProfileFolder",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.image.arn}/profile/*"
      }
    ]
  })
}

resource "aws_s3_bucket_cors_configuration" "image" {
  bucket = aws_s3_bucket.image.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT"]
    allowed_origins = [
      "http://localhost:5173",
      "https://ktbkoco.com",
      "https://koco-admin.o-r.kr"
    ]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}
