output "rds_cluster_id" {
  description = "The RDS cluster identifier"
  value       = module.rds_aurora.cluster_id
}

output "rds_cluster_arn" {
  description = "The ARN of the RDS cluster"
  value       = module.rds_aurora.cluster_arn
}

output "rds_cluster_endpoint" {
  description = "The cluster endpoint for write operations"
  value       = module.rds_aurora.cluster_endpoint
}

output "rds_cluster_reader_endpoint" {
  description = "The cluster reader endpoint for read-only operations"
  value       = module.rds_aurora.cluster_reader_endpoint
}

output "rds_cluster_port" {
  description = "The port of the RDS cluster"
  value       = module.rds_aurora.cluster_port
}

output "rds_cluster_resource_id" {
  description = "The resource ID of the RDS cluster"
  value       = module.rds_aurora.cluster_resource_id
}

output "rds_cluster_members" {
  description = "List of RDS instances that are part of this cluster"
  value       = module.rds_aurora.cluster_members
}

output "rds_cluster_database_name" {
  description = "The database name"
  value       = module.rds_aurora.cluster_database_name
}

output "db_subnet_group_id" {
  description = "The DB subnet group ID"
  value       = aws_db_subnet_group.database.id
}
