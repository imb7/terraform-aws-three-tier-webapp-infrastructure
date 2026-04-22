variable "ubuntu_ami_id" {
  description = "AMI ID for the bastion host"
  type        = string
}

variable "key_pair_name" {
  description = "key-pair for ssh"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the bastion host"
  type        = string
}

variable "public_subnet_id" {
  description = "Subnet ID for the bastion host"
  type        = string
}

variable "bastion_sg_id" {
  description = "ID of the bastion security group"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile for the bastion host"
  type        = string
}