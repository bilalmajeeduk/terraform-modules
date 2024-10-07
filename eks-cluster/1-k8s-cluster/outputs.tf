#####################
# AWS EKS CLUSTER
#####################

output "cluster_arn" {
  description = "AWS EKS CLUSTER"
  value = module.eks.cluster_arn
}
output "cluster_certificate_authority_data" {
  description = "Base64_encoded certificate data required to communicate with the cluster"
  value = module.eks.cluster_certificate_authority_data
}
output "cluster_endpoint" {
  description = "Endpoint of the AWS EKS K8s API_SERVER"
  value = module.eks.cluster_endpoint
}
output "cluster_id" {
  description = "THE ID OF THE AWS EKS CLUSTER"
  value = module.eks.cluster_id
}
output "cluster_name" {
  description = ""
  value = module.eks.cluster_name
}

output "cluster_oidc_issuer_url" {
  description = "The URL of the AWS EKS cluster for the OpenID_Connect_identity_provider"
  value       = module.eks.cluster_oidc_issuer_url
}

output "cluster_platform_version" {
  description = "Platform version for the AWS EKS CLUSTER"
  value       = module.eks.cluster_platform_version
}

output "cluster_status" {
  description = "Status of the EKS cluster. One of `CREATING`, `ACTIVE`, `DELETING`, `FAILED`"
  value       = module.eks.cluster_status
}

output "cluster_primary_security_group_id" { # R
  description = "Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication. Referred to as 'Cluster security group' in the EKS console"
  value       = module.eks.cluster_primary_security_group_id
}

output "cluster_service_cidr" {
  description = "The CIDR block where Kubernetes pod and service IP addresses are assigned from 'VPC' "
  value       = module.eks.cluster_service_cidr
}

output "cluster_ip_family" {
  description = "The IP family used by the cluster (e.g. `ipv4` or `ipv6`)"
  value       = module.eks.cluster_ip_family
}

output "cluster_version" {
  description = "The version of the AWS EKS cluster"
  value       = module.eks.cluster_version
}

#####################
# AWS IAM ROLE
#####################

output "cluster_iam_role_name" {
  description = "IAM role name of the EKS cluster"
  value       = module.eks.cluster_iam_role_name
}

output "cluster_iam_role_arn" {
  description = "IAM role ARN of the EKS cluster"
  value       = module.eks.cluster_iam_role_arn
}

output "cluster_iam_role_unique_id" {
  description = "Stable and unique string identifying the IAM role"
  value       = module.eks.cluster_iam_role_unique_id
}

#####################
# AWS Fargate Profile
#####################

output "fargate_profiles" {
  description = "AWS EKS cluster profile created."
  value = module.vpc.fargate_profile
}

#####################
# AWS VPC
#####################
output "vpc_id" {
  description = "Cluster AWS VPC ID"
  value       = module.vpc.vpc_id
}

output "compute_subnets" {
  description = "Subnet IDs for EKS compute nodes"
  value = [module.vpc.private_subnets[0]]
}