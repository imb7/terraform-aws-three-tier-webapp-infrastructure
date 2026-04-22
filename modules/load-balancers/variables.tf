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
  default     = "arn:aws:acm:us-east-1:465630415820:certificate/37be491a-007e-4ded-8895-5b01a13446ea"
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

