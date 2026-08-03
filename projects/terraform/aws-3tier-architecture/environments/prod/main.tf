provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source               = "../../modules/vpc"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]
  enable_nat_gateway   = true
}

module "alb" {
  source            = "../../modules/alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  target_port       = 80
  health_check_path = "/"
}

module "asg" {
  source                = "../../modules/asg"
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.alb.alb_sg_id
  target_group_arn      = module.alb.target_group_arn
}

module "rds" {
  source                    = "../../modules/rds"
  vpc_id                    = module.vpc.vpc_id
  private_subnet_ids        = module.vpc.private_subnet_ids
  allowed_security_group_id = module.asg.app_sg_id
  db_engine                 = "mysql"
  db_instance_class         = "db.t3.micro"
  db_name                   = "appdb"
}
