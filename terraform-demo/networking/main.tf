locals {
  tags = {
    Technology       = var.technology,
    Proyect          = var.proyect,
    Area             = var.area,
    Environment      = local.environment,
    SolutionDesigner = var.solution_designer,
    Responsable      = var.responsable
  }
}

module "vpc" {
  # REQUIRED
  source      = "../terraform_modules/networking/vpc"
  prefix      = var.prefix
  environment = local.environment
  proyect     = var.proyect
  tags        = merge(local.tags, var.tags_vpc)

  create_vpc                 = var.create_vpc
  cidr_vpc                   = var.cidr_main_vpc
  enable_dns_support         = var.enable_dns_support
  enable_dns_hostnames       = var.enable_dns_hostnames
  create_internet_gateway    = var.create_internet_gateway
  create_default_network_acl = var.create_default_network_acl
}

module "subnets" {
  # REQUIRED
  source = "../terraform_modules/networking/subnets"

  prefix      = var.prefix
  environment = local.environment
  proyect     = var.proyect
  application = var.application_subnet
  tags        = merge(local.tags, var.tags_subnets)

  cidr_block              = var.cidr_block_subnets
  availability_zones      = var.availability_zones_subnets
  map_public_ip_on_launch = var.map_public_ip_on_launch
  create_subnets_private  = var.create_subnets_private
  create_subnets_public   = var.create_subnets_public
  nat_gateway_enabled     = var.nat_gateway_enabled
  vpc_id                  = module.vpc.main_vpc_id[0]
  igw_id                  = module.vpc.igw_id[0]
}