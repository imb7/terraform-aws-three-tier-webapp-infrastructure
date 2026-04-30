# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#   RDS Aurora Cluster Outputs                                                   #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

output "cluster_id" {
  description = "The RDS cluster identifier"
  value       = module.rds_aurora.cluster_id
}

output "cluster_arn" {
  description = "Amazon Resource Name (ARN) of the RDS Aurora cluster"
  value       = module.rds_aurora.cluster_arn
}

output "cluster_endpoint" {
  description = "The cluster endpoint - use this for write operations"
  value       = module.rds_aurora.cluster_endpoint
}

output "cluster_reader_endpoint" {
  description = "The cluster reader endpoint - use this for read-only operations"
  value       = module.rds_aurora.cluster_reader_endpoint
}

output "cluster_port" {
  description = "The port on which the cluster accepts connections"
  value       = module.rds_aurora.cluster_port
}

output "cluster_resource_id" {
  description = "The RDS Cluster Resource ID"
  value       = module.rds_aurora.cluster_resource_id
}

output "cluster_database_name" {
  description = "The database name created on cluster creation"
  value       = module.rds_aurora.cluster_database_name
}

output "cluster_master_username" {
  description = "The master username for the database"
  value       = module.rds_aurora.cluster_master_username
  sensitive   = true
}

output "cluster_members" {
  description = "List of RDS Cluster member instance identifiers"
  value       = module.rds_aurora.cluster_members
}

output "cluster_instances" {
  description = "A map of cluster instances and their attributes"
  value       = module.rds_aurora.cluster_instances
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#   Cluster Metadata Outputs                                                    #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

output "cluster_engine_version_actual" {
  description = "The running version of the cluster database engine"
  value       = module.rds_aurora.cluster_engine_version_actual
}

output "cluster_ca_certificate_identifier" {
  description = "CA identifier of the CA certificate used for the database instance's server certificate"
  value       = module.rds_aurora.cluster_ca_certificate_identifier
}

output "cluster_hosted_zone_id" {
  description = "The Route53 Hosted Zone ID of the endpoint"
  value       = module.rds_aurora.cluster_hosted_zone_id
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#   Secrets Manager Outputs (Password Rotation)                                 #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

output "cluster_master_user_secret" {
  description = "The generated database master user secret when manage_master_user_password is set to true"
  value       = module.rds_aurora.cluster_master_user_secret
  sensitive   = true
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#   Parameter Group Outputs                                                     #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

output "db_cluster_parameter_group_id" {
  description = "The ID of the DB cluster parameter group created"
  value       = module.rds_aurora.db_cluster_parameter_group_id
}

output "db_cluster_parameter_group_arn" {
  description = "The ARN of the DB cluster parameter group created"
  value       = module.rds_aurora.db_cluster_parameter_group_arn
}

output "db_parameter_group_id" {
  description = "The ID of the DB parameter group created"
  value       = module.rds_aurora.db_parameter_group_id
}

output "db_parameter_group_arn" {
  description = "The ARN of the DB parameter group created"
  value       = module.rds_aurora.db_parameter_group_arn
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#   Database Subnet Group Outputs                                               #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

output "db_subnet_group_name" {
  description = "The name of the DB subnet group"
  value       = aws_db_subnet_group.database.name
}

output "db_subnet_group_id" {
  description = "The ID of the DB subnet group"
  value       = aws_db_subnet_group.database.id
}

output "db_subnet_group_arn" {
  description = "The ARN of the DB subnet group"
  value       = aws_db_subnet_group.database.arn
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#   Monitoring and Logging Outputs                                              #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

output "enhanced_monitoring_iam_role_arn" {
  description = "The ARN of the enhanced monitoring IAM role"
  value       = try(module.rds_aurora.enhanced_monitoring_iam_role_arn, null)
}

output "enhanced_monitoring_iam_role_name" {
  description = "The name of the enhanced monitoring IAM role"
  value       = try(module.rds_aurora.enhanced_monitoring_iam_role_name, null)
}

output "db_cluster_cloudwatch_log_groups" {
  description = "Map of CloudWatch log groups created and their attributes"
  value       = try(module.rds_aurora.db_cluster_cloudwatch_log_groups, {})
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#   Security Group Outputs                                                      #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

output "security_group_id" {
  description = "The security group ID of the Aurora cluster (if created by the module)"
  value       = try(module.rds_aurora.security_group_id, null)
}
