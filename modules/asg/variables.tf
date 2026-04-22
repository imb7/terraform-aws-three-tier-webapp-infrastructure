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
#   external ASG variables    #
# # # # # # # # # # # # # # # #

variable "web_min_size" {
  description = "Minimum number of instances in the web ASG"
  type        = number
  default     = 1
}

variable "web_max_size" {
  description = "Maximum number of instances in the web ASG"
  type        = number
  default     = 2
}

variable "web_desired_capacity" {
  description = "Desired number of instances in the web ASG"
  type        = number
  default     = 1
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the ASG"
  type        = list(string)
}

variable "web_launch_template_id" {
  description = "ID of the web tier launch template"
  type        = string
}

variable "external_target_group_arns" {
  description = "List of target group ARNs to attach to the ASG"
  type        = list(string)
}



# # # # # # # # # # # # # # # #
#   internal ASG variables    #
# # # # # # # # # # # # # # # #

variable "app_min_size" {
  description = "Minimum number of instances in the app ASG"
  type        = number
  default     = 1
}

variable "app_max_size" {
  description = "Maximum number of instances in the app ASG"
  type        = number
  default     = 2
}

variable "app_desired_capacity" {
  description = "Desired number of instances in the app ASG"
  type        = number
  default     = 1
}

variable "app_launch_template_id" {
  description = "ID of the app tier launch template"
  type        = string
}

variable "internal_target_group_arns" {
  description = "List of target group ARNs to attach to the ASG"
  type        = list(string)
}

