# data "aws_availability_zones" "available" {}

module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "8.0.0"
  name = "${local.name}-autoscaling"
  min_size                  = 2
  max_size                  = 5
  desired_capacity          = 4
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier = [module.vpc.public_subnets[0], module.vpc.public_subnets[1]]
  
  # vpc_zone_identifier       = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]


# Launch template where we configure EC2 
  launch_template_name        = "complete-${local.name}"
  launch_template_description = "it configured the launch templates for EC2 instances."
  update_default_version      = true

  image_id          = data.aws_ami.this.id
  instance_type     = "t3.micro"

  security_groups = [module.web_server_sg.security_group_id]
  user_data         = filebase64("userdata.sh")
  #this example is from the complete github can't use the below this
  traffic_source_attachments = {
    ex-alb = {
      traffic_source_identifier = module.alb.target_groups.web_server_target_group.arn
      traffic_source_type       = "elbv2" # default
    }
  } 


   # this is not expected here not error.
  # target_groups = ["${module.alb.target_groups.web_server_target_group.arn}"]
}

module "web_server_sg" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"
  name        = "web-server"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = module.vpc.vpc_id
  ingress_cidr_blocks = [module.vpc.vpc_cidr_block]
}