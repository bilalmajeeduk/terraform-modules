module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"
  comment = "cdn and s3 trying to make a static website by bilal."
  # for production use only, otherwise use stagging = true
  aliases = [data.aws_route53_zone.hosted_zone.name]

  enabled             = true
#  when tf deployed doesn't mean cdn is deployed and ready, it will take time as I know. 
  wait_for_deployment = false

  logging_config = {
    prefix = "cloudfront"
    bucket = module.log_bucket.s3_bucket_bucket_regional_domain_name
  }

  origin = {
    s3_origin = {
      domain_name = module.s3_bucket.s3_bucket_bucket_regional_domain_name
    }
  }

  default_root_object = "index.html"
  default_cache_behavior = {
    target_origin_id       = "s3_origin"
    viewer_protocol_policy = "allow-all"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true
  }
  ordered_cache_behavior = [
    {
      path_pattern           = "*"
      target_origin_id       = "s3_origin"
      #important detail - http to https.
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods  = ["GET", "HEAD"]
      compress        = true
      query_string    = true
    }
  ]

  viewer_certificate = {
    acm_certificate_arn = aws_acm_certificate.cert.arn
    ssl_support_method  = "sni-only" # Server Name Indication(SNI) to serve HTTPS requests.
  }
   custom_error_response = [{
    error_code         = 404
    response_code      = 200
    response_page_path = "/error.html"
    }, {
    error_code         = 403
    response_code      = 200
    response_page_path = "/error.html"
  }]
}

# This data source retrieves the canonical(order by) user ID 
# associated with the currently authenticated AWS account.
data "aws_canonical_user_id" "current" {}
# the canonical user ID used by AWS CloudFront for log delivery to S3.
data "aws_cloudfront_log_delivery_canonical_user_id" "cloudfront" {}

module "log_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0"

  bucket = "logs-${data.aws_route53_zone.hosted_zone.name}"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  grant = [{
    type       = "CanonicalUser"
    permission = "FULL_CONTROL"
    id         = data.aws_canonical_user_id.current.id
    }, {
    type       = "CanonicalUser"
    permission = "FULL_CONTROL"
    id         = data.aws_cloudfront_log_delivery_canonical_user_id.cloudfront.id
  }]
  force_destroy = true
}

resource "aws_route53_record" "cdn" {
  zone_id = data.aws_route53_zone.hosted_zone.id
  name    = ""
  type    = "A"
    # it routes traffic to this cdn as we shared 
  alias {
    name                   = module.cdn.cloudfront_distribution_domain_name
    zone_id                = module.cdn.cloudfront_distribution_hosted_zone_id
    evaluate_target_health = false
  }
}