provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
}

module "networking" {
  source         = "./modules/networking"
  vpc_id         = module.vpc.vpc_id
  public_azs     = var.public_azs
  private_azs    = var.private_azs
}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
}

module "bastion" {
  source     = "./modules/bastion"
  subnet_id  = module.networking.public_subnet_ids[0]
  sg_id      = module.security.bastion_sg_id
  key_name   = var.key_name
}

module "nodes" {
  source     = "./modules/nodes"
  subnet_id  = module.networking.private_subnet_ids[0]
  sg_id      = module.security.nodes_sg_id
  key_name   = var.key_name
}

module "alb" {
  source            = "./modules/alb"
  name              = "k3s"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  sg_id             = module.security.alb_sg_id
  node_ip           = module.nodes.worker_private_ips[0]
  node_port         = 30080
}
