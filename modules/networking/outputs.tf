output "vpc_id" {
  description = "The ID of the VPC created by this module."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets created by this module."
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets created by this module."
  value       = module.vpc.private_subnets
}

output "database_subnet_ids" {
  description = "The IDs of the database subnets created by this module."
  value       = module.vpc.database_subnets
}