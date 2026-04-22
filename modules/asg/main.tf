# ASG module for both web tiers.
module "web_asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 9.0"

  name = "${var.project_name}-${var.environment}-web-asg"

  vpc_zone_identifier = var.private_subnet_ids

  min_size         = var.web_min_size
  max_size         = var.web_max_size
  desired_capacity = var.web_desired_capacity

  create_launch_template  = false
  launch_template_id      = var.web_launch_template_id
  launch_template_version = "$Latest"

  # updated according to the new module version, the traffic source attachment is now a map instead of a list of maps
  traffic_source_attachments = {
    alb_tg = {
      target_group_arn          = var.external_target_group_arns[0]
      traffic_source_identifier = var.external_target_group_arns[0]
    }
  }

  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag_specifications = [
    {
      resource_type = "instance"
      tags = {
        Name        = "${var.project_name}-${var.environment}-web-instance"
        Environment = var.environment
        Tier        = "web"
      }
    }
  ]

  tags = {
    Environment = var.environment
    Tier        = "web"
  }
}


# ASG for the app tier
module "app_asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 9.0"

  name = "${var.project_name}-${var.environment}-app-asg"

  vpc_zone_identifier = var.private_subnet_ids

  min_size         = var.app_min_size
  max_size         = var.app_max_size
  desired_capacity = var.app_desired_capacity

  create_launch_template  = false
  launch_template_id      = var.app_launch_template_id
  launch_template_version = "$Latest"

  # updated according to the new module version, the traffic source attachment is now a map instead of a list of maps
  traffic_source_attachments = {
    alb_tg = {
      target_group_arn          = var.internal_target_group_arns[0]
      traffic_source_identifier = var.internal_target_group_arns[0]
    }
  }

  health_check_type         = "ELB"
  health_check_grace_period = 300

  tag_specifications = [
    {
      resource_type = "instance"
      tags = {
        Name        = "${var.project_name}-${var.environment}-app-instance"
        Environment = var.environment
        Tier        = "app"
      }
    }
  ]

  tags = {
    Environment = var.environment
    Tier        = "app"
  }
}
