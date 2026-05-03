# # # # # # # # # # # # # # # #
#     General variables       #
# # # # # # # # # # # # # # # #

variable "project_name" {
  description = "name of the project"
  type        = string
  default     = "Three-tier-app"
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


# # # # # # # # # # # # # # # #
#      ALB  - variables       #
# # # # # # # # # # # # # # # #

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate for HTTPS listener"
  type        = string
  default     = "null" #provided in terraform.tfvars to avoid hardcoding in root module.
}

variable "vpc_id" {
  description = "vpc_id to deploy the ALB into"
  type        = string
}

variable "public_subnet_ids" {
  description = "list ofpublic subnet ids"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "list of private subnet ids"
  type        = list(string)
}

variable "external_alb_sg_id" {
  description = "security group ID for the external ALB"
  type        = string
}

variable "internal_alb_sg_id" {
  description = "security group ID for the internal ALB"
  type        = string
}

