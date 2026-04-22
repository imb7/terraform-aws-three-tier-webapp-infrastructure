# # # # # # # # # # # # # # # #
#   Networking VPC Module     #
# # # # # # # # # # # # # # # #

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.5.1"

  name = "${var.project_name}-${var.environment}-vpc"
  cidr = var.vpc_cidr_block

  azs = var.availability_zones

  public_subnets   = var.public_subnets
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
}

