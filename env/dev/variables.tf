# # # # # # # # # # # # # # # #
#     General variables       #
# # # # # # # # # # # # # # # #

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

# # # # # # # # # # # # # # # #
#     ALB module variables    #
# # # # # # # # # # # # # # # #

variable "acm_certificate_arn" {
  description = "ARN of the ACM certificate for HTTPS listener"
  type        = string
  default     = "arn:aws:acm:us-east-1:848704296258:certificate/d752e035-73f0-4b4d-8896-a8fbd9b05c7b"
}