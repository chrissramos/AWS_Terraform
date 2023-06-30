module "vpc" {
  source             = "./modules/network"
  vpc_cidr           = var.vpc_module["vpc_cidr"]
}

module "launch_template" {
  source        = "./modules/EC2"
  vpc_id        = module.vpc.vpc_id
  instance_size = var.launch_template_module["instance_size"]
  disk_size     = var.launch_template_module["disk_size"]
  ami           = var.launch_template_module["ami"]
  project_name  = var.project_name
  efs_system = module.efs.efs_system
}

module "asg" {
  source       = "./modules/AutoScalling_Grp"
  lc_id        = module.launch_template.ec2_id
  subnets      = module.vpc.private_subnets
  project_name = var.project_name
  efs_mount  = module.efs.efs_mount
  efs_system = module.efs.efs_system
  elb = module.elb.elb
}

module "efs" {
  source       = "./modules/EFS"
  subnet =  module.vpc.private_subnets
  security_group = module.launch_template.security_grp_launch
  lauch_template = module.launch_template.lauch_template
}

module "elb" {
  source       = "./modules/LoadBalancer"
  subnet =  module.vpc.public_subnets
  security_group = module.launch_template.security_grp_launch
}

module "route53" {
  source       = "./modules/Route53"
  route53 =  var.route53
  lb = module.elb.elb
}