module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.13.0"


  name = local.name
  cidr = local.vpc_cidr

  azs                 = local.azs
  private_subnets     = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets      = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]
#    intra_subnet used for internal communication within a network, such as for application servers
#    or internal services that do not need to be publicly accessible, 
#    and are separate from public and private subnets.
#   intra_subnets       = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 20)]

  enable_nat_gateway = true
  single_nat_gateway = true
  manage_default_security_group = false
  #it will allow public subnets to assign IPs to their ec2 instances otherwise, 
  #don't work. and then have to recreate the whole VPC again
  map_public_ip_on_launch = true
}