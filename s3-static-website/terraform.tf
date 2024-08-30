terraform {
  required_providers {
    aws = {
      # it gets the latest version if we dont specify
      source = "hashicorp/aws"
      # version = "~> 5.0"  # This allows any version >= 5.0.0 and < 6.0.0
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      "Environment" = "testing"
      "Project"     = "s3-static-website-cdn-route53"
      "purpose" = "portfolio project"
    }
  }
}