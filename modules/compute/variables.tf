# Variables for the compute module
variable "ubuntu_ami_id" {
  description = "AMI ID for the bastion host"
  type        = string
}

variable "key_pair_name" {
  description = "Name of the EC2 key pair to use for SSH access"
  type        = string
}

variable "ec2_instance_profile" {
  description = "Name of the IAM role to attach to EC2 instances"
  type        = string
}

variable "web_sg_id" {
  description = "ID of the web security group"
  type        = string
}

variable "app_sg_id" {
  description = "ID of the application security group"
  type        = string
}

