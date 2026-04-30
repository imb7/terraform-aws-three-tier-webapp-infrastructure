# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#   General Project Variables                                                    #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

variable "project_name" {
  description = "name of the project"
  type        = string
  default     = "three-tier-app"
}

variable "environment" {
  description = "deployment environment"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#   VPC and Network Variables                                                    #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

variable "vpc_id" {
  description = "VPC ID where the database will be deployed"
  type        = string
}

variable "database_subnet_ids" {
  description = "List of database subnet IDs for the DB subnet group (minimum 2 across different AZs)"
  type        = list(string)

  validation {
    condition     = length(var.database_subnet_ids) >= 2
    error_message = "At least 2 database subnets are required (across different AZs)."
  }
}

variable "db_security_group_id" {
  description = "Security group ID for the database cluster"
  type        = string
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#   Aurora MySQL Engine Configuration                                            #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Engine version and database name are hardcoded in main.tf (8.0.mysql_aurora.3.04.0)

variable "master_username" {
  description = "Master username for the database cluster"
  type        = string
  default     = "admin"
  sensitive   = true

  validation {
    condition     = length(var.master_username) >= 1 && length(var.master_username) <= 16
    error_message = "Master username must be between 1 and 16 characters."
  }
}

variable "master_password" {
  description = "Master password for the database cluster (should be stored securely in AWS Secrets Manager)"
  type        = string
  default     = "admin1234"
  sensitive   = true


  validation {
    condition     = var.master_password == null || (length(var.master_password) >= 8 && length(var.master_password) <= 41)
    error_message = "Master password must be between 8 and 41 characters if provided."
  }

}

variable "master_password_version" {
  description = "since password_wo does not store password in state file we need version to track if its changed"
  type = string
  default = "1"
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#   Backup and Maintenance Configuration                                         #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

variable "backup_retention_period" {
  description = "Number of days to retain automated backups (1-35). Use 1 for dev to minimize costs"
  type        = number
  default     = 1

  validation {
    condition     = var.backup_retention_period >= 1 && var.backup_retention_period <= 35
    error_message = "Backup retention period must be between 1 and 35 days."
  }
}

variable "apply_immediately" {
  description = "Apply changes immediately instead of during maintenance window"
  type        = bool
  default     = false
}
