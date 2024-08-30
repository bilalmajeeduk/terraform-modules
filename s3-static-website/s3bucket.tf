module "s3_bucket" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  #we attach policy line 27
  attach_policy = true
  # it create bucket and select the name same as hosted zone.
  bucket        = data.aws_route53_zone.hosted_zone.name

  versioning = {
    enabled = false
  }

  website = {
    index_document = "index.html"
    error_document = "error.html"
  }

  block_public_policy     = false
  block_public_acls       = false
  ignore_public_acls      = false
  restrict_public_buckets = false
  policy                  = data.aws_iam_policy_document.bucket_policy.json
}

# it creates new document then to create new IAM policy. not aws managed. 
data "aws_iam_policy_document" "bucket_policy" {
  statement {
    principals {
      type        = "*" # e.g., AWS accounts, IAM users, roles, or services
      # This policy will apply to anyone and everyone. 
      # It doesn't restrict access to specific users or roles, making it a public policy.
      identifiers = ["*"] 
    }

    actions = [
      # Any principal (because of the * identifiers) can download 
      # or read files from the S3 bucket, but they cannot perform any other actions,
      # such as uploading or deleting files.
      "s3:GetObject",
    #   "s3:PutObject",
    #   "s3:DeleteObject"
    ]

    resources = [
      "${module.s3_bucket.s3_bucket_arn}/*",
    ]
  }
}