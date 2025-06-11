provider "aws" {
  region = var.region
  access_key = "AKIARW5DC4EKNETIODVE"
  secret_key = "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"
  # token = "IQoJb3JpZ2luX2VjEFAaCXVzLXdlc3QtMiJHMEUCIQCsnaX4TaO7mE4P/1IgrGfHN0SoFXwYiqzboIpMIMndaAIgLovjM1wl9qkPSDlB/z5MuHTz1CSKzk16SlCB5Sv8wHgqtQIIKRABGgwyNTU0Mjg2MjY0MTkiDOKEX4XFYaWYerZYwiqSAqAwvSiS1H76ve6+oHrnOZtD1pCJFMeAIW6YaRbt0h9Tr/8LeDscOYRKKJVF1EW/JJoITQ00GgBOeMnhinGlmoJSPMPhm1ItjSl2wReqkUtGgFKsTrHuyBeCzcsEzQpHHfLD8FeUQd+ouRf1Ac1/aMPBXMNYO2outGNJyEKObDbKSiIZr6gmtAEoxw2kWWrWa4zZNqgR7BzK8Rrp/nB/74tYrzzE3trr2mkesd3u+408Yitjev2xPMFxpcLa3WqZj+BdGYQXFN+D/csfpSjnqKKJeCgbMs0eL6fwEBVS/N22Opr3mndU/F3fm2QfC+GS9PWZHUDRSOBhJNVAFeVdzl6CRtgFfTg43GOPpBuK8QqLFScwlun/wQY6nQHqc3yBUa6AU3TPI3lIxSvB2UH+BX2s7Dxwawa7p9AYItYSdlIaiirt2Xp1HfRJTHq4kod3Y4P/NZQc3I9mVcywPJy+wr1Od2lUHGpQbi0yZC3zpWHxOuNFCgH70+RHqMVojdg0aer8EN2PmOw0Iiu0zvJ/QFd1EOaId6ZHeooeWJOXx0Ag2KssaAZfMRPL/LiYDSi/SbZ86DH45ikS"
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
