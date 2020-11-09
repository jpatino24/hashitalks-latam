#---------------------------------------------------------------------------------------
# MODULES
#---------------------------------------------------------------------------------------
##-----
## VPC
##-----
create_vpc                 = true
enable_dns_support         = true
enable_dns_hostnames       = true
create_default_network_acl = true
create_internet_gateway    = true
cidr_main_vpc              = "172.31.0.0/24"
tags_vpc = {
  BuildingBlock = "Networking"
}

##---------
## SUBNETS
##---------

#Backbone
nat_gateway_enabled        = false
create_subnets_public      = true
create_subnets_private     = true
map_public_ip_on_launch    = true
application_subnet         = "backbone"
cidr_block_subnets         = "172.31.0.0/24"
availability_zones_subnets = ["us-east-2a", "us-east-2b"] #Ver region
tags_subnets = {
  BuildingBlock = "Networking"
}
