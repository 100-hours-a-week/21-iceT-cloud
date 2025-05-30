variable "bucket_name" {
  description = "Frontend static hosting bucket name"
  type        = string
  default = "koco-front-s3"
}
variable "cloudfront_oai_arn" {
  description = "CloudFront Origin Access Identity의 IAM ARN"
  type        = string
}
