# FIRST_CREATE THE S3 RESOURCE THEN UNCOMMENT THIS.
# terraform {
#   backend "local" {
#     path = "terraform.tfstate"
#   }
# }

# in the next apply with new resources it will upload that
terraform {
  backend "s3" {
    region = "us-east-1"
    bucket = "testing-infrastrucuture-like-gd360-tfstate"
    key = "k8s-cluster-tf.tfstate"
    dynamodb_table = "testing-infrastrucuture-like-gd360-tfstate"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
        k8s_cluster="like-gd360"
        k8s_namespace= "kube-system"
    }
  }
}

resource "aws_s3_bucket" "tf-state" {
  bucket = "testing-infrastrucuture-like-gd360-tfstate"
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket" "tf-statea" {
  bucket = "testing-infrastrucuture-like-gd360-tfstaate"
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_s3_bucket_versioning" "tf-state" {
  bucket = aws_s3_bucket.tf-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "tf-state" {
  bucket = aws_s3_bucket.tf-state.id
# All interactions with the S3 bucket must be over HTTPS.
# Any objects uploaded must use server-side encryption with AES-256.
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "RequireEncryption",
   "Statement": [
    {
      "Sid": "RequireEncryptedTransport",
      "Effect": "Deny",
      "Action": ["s3:*"],
      "Resource": ["arn:aws:s3:::${aws_s3_bucket.tf-state.bucket}/*"],
      "Condition": {
        "Bool": {
          "aws:SecureTransport": "false"
        }
      },
      "Principal": "*"
    },
    {
      "Sid": "RequireEncryptedStorage",
      "Effect": "Deny",
      "Action": ["s3:PutObject"],
      "Resource": ["arn:aws:s3:::${aws_s3_bucket.tf-state.bucket}/*"],
      "Condition": {
        "StringNotEquals": {
          "s3:x-amz-server-side-encryption": "AES256"
        }
      },
      "Principal": "*"
    }
  ]
}
EOF
}

#dynamboDB table for multiple users to work on the same file by locking the tf state.
resource "aws_dynamodb_table" "terraform_state_lock" {
  name = "testing-infrastrucuture-like-gd360-tfstate"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 10 

  attribute {
    name = "LockID"
    type = "S"
  }
}



data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}
