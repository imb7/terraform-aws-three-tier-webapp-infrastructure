module "data" {
  source = "../../data"
}

module "networking" {
  source = "../../modules/networking"
}


module "security" {
  source = "../../modules/security-groups"

  vpc_id = module.networking.vpc_id
}


module "iam" {
  source = "../../modules/iam"
}


module "key_pair" {
  source = "../../modules/key-pair"
}


module "compute" {
  source = "../../modules/compute"

  ubuntu_ami_id        = module.data.ubuntu_ami_id
  key_pair_name        = module.key_pair.key_pair_name
  ec2_instance_profile = module.iam.ec2_instance_profile
  web_sg_id            = module.security.web_sg_id
  app_sg_id            = module.security.app_sg_id
}


module "asg" {
  source = "../../modules/asg"

  private_subnet_ids = module.networking.private_subnet_ids

  web_launch_template_id     = module.compute.web_launch_template_id
  external_target_group_arns = module.load_balancers.external_target_group_arns

  app_launch_template_id     = module.compute.app_launch_template_id
  internal_target_group_arns = module.load_balancers.internal_target_group_arns
}


module "load_balancers" {
  source = "../../modules/load-balancers"

  vpc_id = module.networking.vpc_id

  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids

  external_alb_sg_id = module.security.external_alb_sg_id
  internal_alb_sg_id = module.security.internal_alb_sg_id

  acm_certificate_arn = var.acm_certificate_arn
}


module "database" {
  source = "../../modules/database"

  common_tags          = local.common_tags
  vpc_id               = module.networking.vpc_id
  database_subnet_ids  = module.networking.database_subnet_ids
  db_security_group_id = module.security.db_sg_id
}

module "bastion_host" {
  source = "../../modules/bastion-host"

  ubuntu_ami_id        = module.data.ubuntu_ami_id
  vpc_id               = module.networking.vpc_id
  public_subnet_id     = module.networking.public_subnet_ids[0]
  bastion_sg_id        = module.security.bastion_sg_id
  key_pair_name        = module.key_pair.key_pair_name
  iam_instance_profile = module.iam.ec2_instance_profile
}