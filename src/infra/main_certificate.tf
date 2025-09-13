resource "aws_acm_certificate" "website_cert" {
  count             = var.domain_name != "" ? 1 : 0
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "website_cert_validation" {
  count           = var.domain_name != "" ? 1 : 0
  certificate_arn = aws_acm_certificate.website_cert[0].arn
}
