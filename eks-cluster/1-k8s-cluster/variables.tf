variable "cluster_name" {
  type = string
  default = "like-GD360"   
  description = "This is the infrastructure based on the GD360 setting, and folllowing all the requirments and services used there."
}

# variable "vpc_cidr" {
#   type        = string
#   description = "VPC overall network space. Will be automatically subdivided for public, private-with-egress, and private-isolated subnets."
#   default     = "10.0.0.0/16"
#   validation {
#     condition = (can(cidrhost(var.vpc_cidr, 0)) && try(cidrhost(var.vpc_cidr, 0), null) == split("/", var.vpc_cidr)[0])
#     # the above could be simplified to:
#     # condition = cidrhost(var.vpc_cidr, 0) == split("/", var.vpc_cidr)[0]
#     # ...though that would throw "Error in function call" instead of "Invalid
#     # value for variable" were an invalid cidr (10.0.0.x/16) were used.

#     error_message = "InvalidCIDRNotation: The CIDR is not correctly formatted, or the address prefix is invalid for the CIDR's size"
#     # InvalidCIDRNotation is an existing error code; so may be helpful if anyone googles it.
#   }
# }
