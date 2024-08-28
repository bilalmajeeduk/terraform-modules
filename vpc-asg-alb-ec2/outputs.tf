output "web_url" {
  value = module.alb.dns_name
}
output "target_groups" {
#   value = aws_lb_target_group.web_server_target_group.arn
value = module.alb.target_groups.web_server_target_group.arn

}