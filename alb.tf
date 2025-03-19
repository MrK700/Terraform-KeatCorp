module "alb" {
  source = "./modules/alb"
  
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  security_group_id = module.security_groups.alb_sg_id
  environment       = var.environment
  project           = var.project
}

module "asg" {
  source = "./modules/asg"
  
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  instance_security_group_id = module.security_groups.instance_sg_id
  target_group_arns     = [module.alb.target_group_arn]
  environment           = var.environment
  project               = var.project
  instance_type         = var.instance_type
  min_size              = var.min_instance_count
  max_size              = var.max_instance_count
  desired_capacity      = var.desired_instance_count
  user_data             = file("${path.module}/scripts/user_data.sh")
}