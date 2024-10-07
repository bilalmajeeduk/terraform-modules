module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
#   version = "5.13.0"
  version = "~> 5.0"


  name = "like-gd360-vpc"
  cidr = "10.0.0.0/16"

  azs             = local.azs
# adding 4 bits for subnetting (allowing for 16 subnets), and using the index k to differentiate between each AZ.
# Example: If local.vpc_cidr is 10.0.0.0/16, this could generate 10.0.0.0/20, 10.0.16.0/20, etc., depending on the value of k.
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]

#   Purpose: Creates intra-subnets, likely used for internal communication or service-to-service communication within the VPC.
  intra_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 52)]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Advance_Terraform = "true"
    Environment = "dev-testing"
  }
}