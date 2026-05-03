# ALB module for both external and internal load balancers

# external ALB for the public subnets
module "external_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "10.4.0"

  enable_deletion_protection = false

  name   = "${var.project_name}-external-alb"
  vpc_id = var.vpc_id
  subnets = [
    var.public_subnet_ids[0],
    var.public_subnet_ids[1],
  ]

  # Do NOT create SG inside the module
  create_security_group = false

  # Attach your pre-created SGs here
  security_groups = [
    var.external_alb_sg_id
  ]

  listeners = {
    ex-http-https-redirect = {
      port     = 80
      protocol = "HTTP"

      # redirect sends the client a new URL to visit (HTTP 301/302). The browser then makes a new request to that URL.
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }

    ex-https = {
      port     = 443
      protocol = "HTTPS"
    
      # since listener is HTTPS, you must provide a certificate ARN to encrypt the traffic
      certificate_arn = var.acm_certificate_arn
    
      # forward passes the request internally to a target group for processing. The client doesn't know this happens.
      forward = {
        target_group_key = "ex-instance"
      }
    }
  }

  # map of target groups to be created and attached to the ALB. The key is used in the listener configuration above.
  target_groups = {
    ex-instance = {
      protocol          = "HTTP"
      port              = 80
      target_type       = "instance"
      create_attachment = false
    }
  }
}

# internal ALB for the private subnets

module "internal_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "10.4.0"

  enable_deletion_protection = false

  name   = "${var.project_name}-internal-alb"
  vpc_id = var.vpc_id
  subnets = [
    var.private_subnet_ids[0],
    var.private_subnet_ids[1],
  ]

  create_security_group = false

  security_groups = [
    var.internal_alb_sg_id
  ]

  listeners = {
    in-http = {
      port     = 80
      protocol = "HTTP"

      forward = {
        target_group_key = "in-instance"
      }
    }
  }

  target_groups = {
    in-instance = {
      protocol          = "HTTP"
      port              = 80
      target_type       = "instance"
      create_attachment = false
    }
  }
}
