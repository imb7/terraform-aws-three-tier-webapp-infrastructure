# # # # # # # # # # # # # # # #
#   RDS Aurora MySQL Module   #
# # # # # # # # # # # # # # # #

module "rds_aurora" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 9.0"

  name            = "${var.project_name}-${var.environment}-aurora"
  engine          = "aurora-mysql"
  engine_version  = var.engine_version
  family          = "aurora-mysql${var.family_version}"
  major_engine_version = var.family_version

  database_name   = var.database_name
  username        = var.master_username
  password        = var.master_password
  port            = var.database_port

  db_subnet_group_name = aws_db_subnet_group.database.name
  vpc_security_group_ids = [var.db_sg_id]

  # Budget-friendly configuration for dev/testing
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_cluster_parameter_group.name
  db_parameter_group_name         = aws_rds_db_parameter_group.aurora_db_parameter_group.name

  # Single instance for dev/testing (no multi-AZ)
  instance_class   = var.instance_class
  num_instances    = var.number_of_instances

  # Backup configuration (minimal for dev)
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = "03:00-04:00"
  preferred_maintenance_window = "mon:04:00-mon:05:00"

  # Disable features to reduce costs
  enabled_cloudwatch_logs_exports = []
  enable_http_endpoint            = false
  enable_performance_insights      = false
  storage_encrypted               = false

  # Auto-scaling disabled for predictable costs
  autoscaling_enabled = false

  tags = {
    Name = "${var.project_name}-${var.environment}-aurora-cluster"
  }
}

# Database subnet group
resource "aws_db_subnet_group" "database" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.database_subnet_ids

  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  }
}

# Cluster parameter group for Aurora MySQL
resource "aws_rds_cluster_parameter_group" "aurora_cluster_parameter_group" {
  name            = "${var.project_name}-${var.environment}-cluster-params"
  family          = "aurora-mysql${var.family_version}"
  description     = "Cluster parameter group for Aurora MySQL"

  tags = {
    Name = "${var.project_name}-${var.environment}-cluster-params"
  }
}

# DB parameter group for Aurora MySQL
resource "aws_rds_db_parameter_group" "aurora_db_parameter_group" {
  name   = "${var.project_name}-${var.environment}-db-params"
  family = "aurora-mysql${var.family_version}"
  description = "DB parameter group for Aurora MySQL"

  tags = {
    Name = "${var.project_name}-${var.environment}-db-params"
  }
}
