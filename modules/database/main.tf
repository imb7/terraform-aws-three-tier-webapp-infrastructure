# # # # # # # # # # # # # # # # # 
#   RDS Aurora MySQL Cluster    #
# # # # # # # # # # # # # # # # # 

module "rds_aurora" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 10.2"

  # Cluster identification
  name          = "${var.project_name}-${var.environment}-aurora"
  database_name = "applicationdb"

  master_username             = var.master_username
  manage_master_user_password = false
  master_password_wo          = var.master_password
  master_password_wo_version = var.master_password_version

  # Engine and version configuration
  engine         = "aurora-mysql"
  engine_version = "8.0.mysql_aurora.3.04.0"


  engine_mode = "provisioned" # Use provisioned mode for Aurora MySQL

  # Cluster instance configuration - Modern approach using instances map
  cluster_instance_class = "db.t4g.medium"
  instances = {
    writer = {
      instance_class      = "db.t4g.medium"
      publicly_accessible = false
      identifier_prefix   = "writer"
    }
    reader1 = {
      instance_class      = "db.t4g.medium"
      publicly_accessible = false
      identifier_prefix   = "reader-1"
      promotion_tier      = 1
    }
  }

  # Autoscaling configuration for read replicas
  autoscaling_enabled      = false
  autoscaling_min_capacity = 1
  autoscaling_max_capacity = 3
  autoscaling_target_cpu   = 70

  # VPC and Network configuration
  vpc_id                 = var.vpc_id
  port                   = 3306
  db_subnet_group_name   = aws_db_subnet_group.database.name
  vpc_security_group_ids = [var.db_security_group_id]

  # Parameter group configuration
  cluster_parameter_group = {
    name            = "${var.project_name}-${var.environment}-cluster-params"
    use_name_prefix = true
    family          = "aurora-mysql8.0"
    description     = "Cluster parameter group for Aurora MySQL 8.0"
    parameters = [
      {
        name         = "character_set_server"
        value        = "utf8mb4"
        apply_method = "immediate"
      },
      {
        name         = "collation_server"
        value        = "utf8mb4_unicode_ci"
        apply_method = "immediate"
      }
    ]
  }

  db_parameter_group = {
    name            = "${var.project_name}-${var.environment}-params"
    use_name_prefix = true
    family          = "aurora-mysql8.0"
    description     = "DB parameter group for Aurora MySQL 8.0"
    parameters = [
      {
        name         = "slow_query_log"
        value        = "1"
        apply_method = "immediate"
      },
      {
        name         = "long_query_time"
        value        = "2"
        apply_method = "immediate"
      }
    ]
  }

  # Backup and maintenance configuration
  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = "03:00-04:00"
  preferred_maintenance_window = "mon:04:00-mon:05:00"
  copy_tags_to_snapshot        = true
  skip_final_snapshot          = false
  final_snapshot_identifier    = "${var.project_name}-${var.environment}-final-snapshot-${formatdate("YYYY-MM-DD-hhmm", timestamp())}"

  # Security and encryption
  storage_encrypted   = true
  kms_key_id          = null
  deletion_protection = false

  # Monitoring and logging
  enabled_cloudwatch_logs_exports = ["error", "slowquery"]
  cluster_monitoring_interval     = 0
  create_monitoring_role          = false

  # Performance Insights (optional, can reduce costs if disabled)
  cluster_performance_insights_enabled          = false
  cluster_performance_insights_retention_period = null

  # Additional features
  iam_database_authentication_enabled = true
  apply_immediately                   = var.apply_immediately

  # Tagging
  tags = merge(
    var.common_tags,
    {
      Name        = "${var.project_name}-${var.environment}-aurora-cluster"
      Environment = var.environment
      Module      = "database"
    }
  )
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#   Database Subnet Group                                                        #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

resource "aws_db_subnet_group" "database" {
  name_prefix = "${var.project_name}-${var.environment}-db-subnet-"
  subnet_ids  = var.database_subnet_ids
  description = "Database subnet group for ${var.project_name}-${var.environment}"

  tags = merge(
    var.common_tags,
    {
      Name        = "${var.project_name}-${var.environment}-db-subnet-group"
      Environment = var.environment
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}
