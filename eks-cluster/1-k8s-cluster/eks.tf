module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.30"
  cluster_endpoint_public_access  = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true

  access_entries = {
    # One access entry with a policy associated
    root-cluster-admin = {
      kubernetes_groups = []
      principal_arn     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"

      policy_associations = {
        cluster-admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"
          access_scope = {
            type       = "cluster"
          }
        }
      }
    }
  }

   # Use a fargate profile for kube-system workloads, and Karpenter for everything else
  fargate_profiles = {
    kube-system = {
      # Limit to a single subnet to avoid cross-AZ chatter
      subnet_ids = [module.vpc.private_subnets[1]]
      selectors = [
        { namespace = "kube-system" }
      ]
    }
  }

  tags = {
    # NOTE - if creating multiple security groups with this module, only tag the
    # security group that Karpenter should utilize with the following tag
    # (i.e. - at most, only one security group should have this tag in your account)
    "karpenter.sh/discovery" = local.name
    Environment = "dev"
    Advance_Terraform   = "true"
  }
}