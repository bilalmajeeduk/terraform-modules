resource "aws_acm_certificate" "cert" {
  domain_name               = data.aws_route53_zone.hosted_zone.name
  subject_alternative_names = ["*.${data.aws_route53_zone.hosted_zone.name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "validation" {
  zone_id = data.aws_route53_zone.hosted_zone.id
#  tolist:- converts this value into a list (ensuring it's in a list format).
  name    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
  records = [tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value]
  type    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn = aws_acm_certificate.cert.arn
}

# This Terraform configuration is creating a DNS record in
# AWS Route 53 to validate an ACM certificate. When you request
# an SSL certificate from AWS Certificate Manager,
# it often requires you to prove control over the domain 
# by creating a specific DNS record. This resource 
# automatically creates that DNS record in 
# the appropriate hosted zone, allowing the ACM certificate to be validated.