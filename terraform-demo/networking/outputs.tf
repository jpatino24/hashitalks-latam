#OUTPUTS MODULE VPC
output "main_vpc_id" {
  value = module.vpc.main_vpc_id
}

output "main_vpc_tags" {
  value = module.vpc.main_vpc_tags
}

output "main_cidr_block" {
  value = module.vpc.main_cidr_block
}

output "igw_id" {
  value = module.vpc.igw_id
}

output "acl_id" {
  value = module.vpc.acl_id
}

#OUTPUTS MODULE SUBNETS
output "public_subnet_id" {
  value       = module.subnets.public_subnet_id
  description = "The ID of the subnet."
}

output "public_subnet_tags" {
  value = module.subnets.public_subnet_tags
}

output "public_subnet_cidrs" {
  value       = module.subnets.public_subnet_cidrs
  description = "CIDR blocks of the created public subnets."
}

output "private_subnet_id" {
  value       = module.subnets.private_subnet_id
  description = "The ID of the private subnet."
}

output "private_subnet_tags" {
  value = module.subnets.private_subnet_tags
}

output "private_subnet_cidrs" {
  value       = module.subnets.private_subnet_cidrs
  description = "CIDR blocks of the created private subnets."
}

output "public_route_tables_id" {
  value       = module.subnets.public_route_tables_id
  description = "The ID of the routing table."
}

output "private_route_tables_id" {
  value       = module.subnets.private_route_tables_id
  description = "The ID of the routing table."
}

output "ngw_id" {
  value = module.subnets.ngw_id
}

output "region" {
  value = var.region
}