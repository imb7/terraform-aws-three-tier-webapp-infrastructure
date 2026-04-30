# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#   Local Values for Common Configuration                                        #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    CreatedAt   = formatdate("YYYY-MM-DD", timestamp())
  }
}
