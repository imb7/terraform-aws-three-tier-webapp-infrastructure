# RDS Aurora MySQL Module

This module creates a budget-friendly RDS Aurora MySQL database cluster suitable for development and testing environments.

## Features

- **Aurora MySQL Engine**: Uses the `terraform-aws-modules/rds-aurora/aws` module for managed Aurora MySQL
- **Budget-Friendly Configuration**:
  - Single instance by default (no Multi-AZ redundancy)
  - `db.t3.small` instance class (can be reduced to `db.t3.micro`)
  - Minimal backup retention (1 day default)
  - Disabled performance insights and HTTP endpoint
  - No storage encryption (can be enabled for production)

## Inputs

### Required Variables
- `project_name` (string): Name of the project
- `environment` (string): Deployment environment (dev/staging/prod)
- `region` (string): AWS region for resources
- `vpc_id` (string): VPC ID for the database
- `database_subnet_ids` (list): Database subnet IDs for multi-AZ placement
- `db_sg_id` (string): Security group ID for database access
- `master_password` (string): Master database password (8-41 characters, sensitive)

### Optional Variables with Defaults
- `engine_version` (default: `8.0.mysql_aurora.3.02.0`)
- `family_version` (default: `8.0`)
- `database_name` (default: `applicationdb`)
- `master_username` (default: `admin`)
- `database_port` (default: `3306`)
- `instance_class` (default: `db.t3.small`)
- `number_of_instances` (default: `1`)
- `backup_retention_period` (default: `1` day)

## Outputs

- `rds_cluster_id`: The RDS cluster identifier
- `rds_cluster_endpoint`: Cluster endpoint for write operations
- `rds_cluster_reader_endpoint`: Reader endpoint for read-only operations
- `rds_cluster_port`: Database port
- `rds_cluster_members`: List of instances in the cluster

## Usage

### Basic Usage

```hcl
module "database" {
  source = "../../modules/database"

  project_name        = var.project_name
  environment         = var.environment
  region              = var.region
  vpc_id              = module.networking.vpc_id
  database_subnet_ids = module.networking.database_subnet_ids
  db_sg_id            = module.security.db_sg_id
  master_password     = var.master_password
}
```

### Deployment Example

```bash
# Option 1: Set password via CLI (recommended for security)
terraform apply -var="master_password=YourSecurePassword123"

# Option 2: Use terraform.tfvars (less secure - ensure it's in .gitignore)
terraform apply
```

## Cost Optimization Tips

1. **Instance Size**: For lighter testing, use `db.t3.micro` instead of `db.t3.small`
2. **Number of Instances**: Keep at 1 for dev/testing
3. **Backup Retention**: Minimum 1 day to reduce storage costs
4. **No Multi-AZ**: Single instance saves costs (trade-off: no high availability)
5. **No Performance Insights**: Disabled by default to reduce costs

## Production Considerations

For production deployments, consider:
- Increasing `number_of_instances` to 2+ for redundancy
- Enabling `enable_performance_insights = true` for monitoring
- Setting `storage_encrypted = true` for data security
- Increasing `backup_retention_period` to 7+ days
- Enabling `enable_http_endpoint = true` for Data API access (optional)

## Security Notes

- **Master Password**: The password is marked as sensitive and should never be committed to version control
- **Database Subnets**: Place databases in private subnets with proper security groups
- **Secrets Management**: Consider using AWS Secrets Manager for password rotation in production
- **SSL**: Aurora MySQL supports SSL/TLS for connections

## Terraform Registry Module

This module uses the official AWS module:
- **Module**: [terraform-aws-modules/rds-aurora/aws](https://registry.terraform.io/modules/terraform-aws-modules/rds-aurora/aws/)
- **Version**: ~> 9.0
