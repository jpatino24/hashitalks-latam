locals {
  create_vpc                 = var.create_vpc == true ? 1 : 0
  create_default_network_acl = var.create_default_network_acl == true ? 1 : 0
  create_internet_gateway    = var.create_internet_gateway == true ? 1 : 0
  create_vpc_peering         = var.create_vpc_peering == true ? 1 : 0
}
#Module      : VPC
#Description : Terraform module to create VPC with degault network acl

resource "aws_vpc" "main_vpc" {
  count = local.create_vpc

  cidr_block           = var.cidr_vpc
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(map("Name", "${var.prefix}-vpc-${var.environment}-${count.index}"), var.tags)

}

resource "aws_default_network_acl" "acl_vpc" {
  count = local.create_default_network_acl

  default_network_acl_id = aws_vpc.main_vpc[count.index].default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = aws_vpc.main_vpc[count.index].cidr_block
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = merge({ "Name" = "${var.prefix}-acl-vpc-${var.environment}-${count.index}" },
    var.tags
  )

}

resource "aws_internet_gateway" "internet_gateway" {
  count = local.create_internet_gateway

  vpc_id = aws_vpc.main_vpc[count.index].id

  tags = merge({ "Name" = "${var.prefix}-igw-${var.environment}-${count.index}" },
    var.tags
  )
}