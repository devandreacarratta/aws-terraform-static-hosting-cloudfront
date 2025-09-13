resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = module.s3_hosting.s3_bucket_id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${module.s3_hosting.s3_bucket_arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.cloudfront_distribution.arn
          }
        }
      }
    ]
  })
}
