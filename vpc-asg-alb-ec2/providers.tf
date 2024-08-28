terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
    region = "us-east-1"
  default_tags {
    tags = {
      "Environment" = "sample-project-dev"
      "Project"     = "asg-alb-vpc"
    }
  }
}