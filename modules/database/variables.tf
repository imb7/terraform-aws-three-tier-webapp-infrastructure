# # # # # # # # # # # # # # # #
#     General variables       #
# # # # # # # # # # # # # # # #

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, staging, prod)"
  type        = string
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
}

# # # # # # # # # # # # # # # #
#   VPC & Network variables   #
# # # # # # # # # # # # # # # #

variable "vpc_id" {
  description = "VPC ID where the database will be deployed"
  type        = string
}

variable "database_subnet_ids" {
  description = "List of database subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "db_sg_id" {
  description = "Security group ID for the database"
  type        = string
}

# # # # # # # # # # # # # # # #
#   RDS Aurora variables      #
# # # # # # # # # # # # # # # #

variable "engine_version" {
  description = "Aurora MySQL engine version (e.g., 8.0.mysql_aurora.3.02.0)"
  type        = string
  default     = "8.0.mysql_aurora.3.02.0"
}

variable "family_version" {
  description = "Aurora MySQL family version (8.0 or 5.7)"
  type        = string
  default     = "8.0"
}

variable "database_name" {
  description = "Initial database name"
  type        = string
  default     = "applicationdb"
}

variable "master_username" {
  description = "Master username for the database"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "master_password" {
  description = "Master password for the database (must be between 8-41 characters)"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.master_password) >= 8 && length(var.master_password) <= 41
    error_message = "Master password must be between 8 and 41 characters."
  }
}

variable "database_port" {
  description = "Port for the Aurora database"
  type        = number
  default     = 3306
}

variable "instance_class" {
  description = "DB instance class (use small instances for dev/testing to save costs)"
  type        = string
  default     = "db.t3.small"
}

variable "number_of_instances" {
  description = "Number of Aurora instances (use 1 for dev/testing to reduce costs)"
  type        = number
  default     = 1

  validation {
    condition     = var.number_of_instances >= 1 && var.number_of_instances <= 3
    error_message = "Number of instances must be between 1 and 3."
  }
}

variable "backup_retention_period" {
  description = "Backup retention period in days (use 1-7 for dev to save costs)"
  type        = number
  default     = 1

  validation {
    condition     = var.backup_retention_period >= 1 && var.backup_retention_period <= 35
    error_message = "Backup retention period must be between 1 and 35 days."
  }
}
