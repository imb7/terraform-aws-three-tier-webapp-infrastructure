# # # # # # # # # # # # # # # #
#       Security Groups        #
# # # # # # # # # # # # # # # #


module "external_alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "external-alb-sg-${var.project_name}"
  description = "Security group for public ALB"
  vpc_id      = var.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule        = "http-80-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      rule        = "https-443-tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.web_sg.security_group_id
    }
  ]
}


module "web_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "web-sg-${var.project_name}"
  description = "Security group for web tier"
  vpc_id      = var.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.external_alb_sg.security_group_id
    },
    {
      rule                     = "ssh-tcp"
      source_security_group_id = module.bastion_sg.security_group_id
    }
  ]

  # Internal: web tier → internal ALB (scoped, secure)
  egress_with_source_security_group_id = [
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      source_security_group_id = module.internal_alb_sg.security_group_id
    }
  ]

  # External: outbound internet access via NAT Gateway
  egress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow outbound HTTP"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow outbound HTTPS"
    }
  ]

  # Outbound: DNS (required for package downloads)
  egress_rules = [
    "dns-udp",
    "dns-tcp"
  ]
}


module "internal_alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "internal-alb-sg-${var.project_name}"
  description = "Security group for internal ALB"
  vpc_id      = var.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.web_sg.security_group_id
    }
  ]

  egress_with_source_security_group_id = [
    {
      from_port                = 8080
      to_port                  = 8080
      protocol                 = "tcp"
      source_security_group_id = module.app_sg.security_group_id
    }
  ]
}

module "app_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "app-sg-${var.project_name}"
  description = "Security group for app tier"
  vpc_id      = var.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 8080
      to_port                  = 8080
      protocol                 = "tcp"
      source_security_group_id = module.internal_alb_sg.security_group_id
    },
    {
      rule                     = "ssh-tcp"
      source_security_group_id = module.bastion_sg.security_group_id
    }
  ]

  # Internal: web tier → internal ALB (scoped, secure)
  egress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp" # or postgres
      source_security_group_id = module.db_sg.security_group_id
    }
  ]

  # External: outbound internet access via NAT Gateway
  egress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow outbound HTTP"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "Allow outbound HTTPS"
    }
  ]

  # Outbound: DNS (required for package downloads)
  egress_rules = [
    "dns-udp",
    "dns-tcp"
  ]
}


module "db_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "db-sg-${var.project_name}"
  description = "Security group for database tier"
  vpc_id      = var.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = module.app_sg.security_group_id
    },
    {
      rule                     = "ssh-tcp"
      source_security_group_id = module.bastion_sg.security_group_id
    }
  ]
}


module "bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "bastion-sg-${var.project_name}"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id

  ingress_with_cidr_blocks = [
    {
      rule        = "ssh-tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_source_security_group_id = [
    {
      rule                     = "ssh-tcp"
      source_security_group_id = module.web_sg.security_group_id
    },
    {
      rule                     = "ssh-tcp"
      source_security_group_id = module.app_sg.security_group_id
    },
    {
      rule                     = "ssh-tcp"
      source_security_group_id = module.db_sg.security_group_id
    }
  ]
}


