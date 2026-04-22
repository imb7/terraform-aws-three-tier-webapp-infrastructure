# Outputs for the security groups module
output "external_alb_sg_id" {
  description = "ID of the external ALB security group"
  value       = module.external_alb_sg.security_group_id
}

output "web_sg_id" {
  description = "ID of the web security group"
  value       = module.web_sg.security_group_id
}

output "internal_alb_sg_id" {
  description = "ID of the internal ALB security group"
  value       = module.internal_alb_sg.security_group_id
}

output "app_sg_id" {
  description = "ID of the application security group"
  value       = module.app_sg.security_group_id
}

output "db_sg_id" {
  description = "ID of the database security group"
  value       = module.db_sg.security_group_id
}

output "bastion_sg_id" {
  description = "ID of the bastion security group"
  value       = module.bastion_sg.security_group_id
}

