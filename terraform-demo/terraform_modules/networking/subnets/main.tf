locals {
  public_count               = var.enabled == true && var.create_subnets_public == true ? length(var.availability_zones) : 0
  private_count              = var.enabled == true && var.create_subnets_private == true ? length(var.availability_zones) : 0
  private_nat_gateways_count = var.enabled == true && var.create_subnets_private == true && var.nat_gateway_enabled == true ? 1 : 0

}

#Module      : PUBLIC SUBNETS
#Description : Terraform module to create public with
#              network acl, route table, Elastic IP, nat gateway, flow log.

resource "aws_subnet" "public" {
  count = local.public_count

  vpc_id            = var.vpc_id
  availability_zone = element(var.availability_zones, count.index)

  map_public_ip_on_launch = var.map_public_ip_on_launch

  cidr_block = cidrsubnet(
    signum(length(var.cidr_block)) == 1 ? var.cidr_block : var.cidr_block,
    ceil(log(local.public_count * 2, 2)),
    local.public_count + count.index
  )

  tags = merge({ "Name" = "${var.prefix}-subnet-${var.environment}-${var.application}-pb-${count.index}" },
    var.tags
  )
  lifecycle {
    # Ignore tags added by kubernetes
    ignore_changes = [
      tags,
      tags["kubernetes.io/cluster/eksctl-eks-default-analitica"],
      tags["kubernetes.io/cluster/eksctl-eks-desarrollo-analitica"],
      tags["kubernetes.io/cluster/eksctl-eks-laboratorio-analitica"],
      tags["kubernetes.io/cluster/eksctl-eks-produccion-analitica"],
      tags["kubernetes.io/role/internal-elb"],
      tags["eksctl.io"],
      tags["k8s.io"],
      tags["SubnetType"],
    ]
  }
}

#Module      : NETWORK ACL
#Description : Provides an network ACL resource. You might set up network ACLs with rules
#              similar to your security groups in order to add an additional layer of
#              security to your VPC.

resource "aws_network_acl" "public" {
  count = var.enable_acl == true && var.create_subnets_public == true && signum(length(var.public_network_acl_id)) == 0 ? 1 : 0

  vpc_id     = var.vpc_id
  subnet_ids = aws_subnet.public.*.id

  egress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  egress {
    rule_no         = 101
    action          = "allow"
    ipv6_cidr_block = "::/0"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
  }

  ingress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  ingress {
    rule_no         = 101
    action          = "allow"
    ipv6_cidr_block = "::/0"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
  }

  tags = merge({ "Name" = "${var.prefix}-acl-${var.environment}-${var.application}-pb-${count.index}" },
    var.tags
  )
  depends_on = [aws_subnet.public]
}

#Module      : ROUTE TABLE
#Description : Provides a resource to create a VPC routing table.
resource "aws_route_table" "public" {
  count = local.public_count

  vpc_id = var.vpc_id

  tags = merge({ "Name" = "${var.prefix}-rt-${var.environment}-${var.application}-pb-${count.index}" },
    var.tags
  )
}

#Module      : ROUTE
#Description : Provides a resource to create a routing table entry (a route) in a VPC
#              routing table.
resource "aws_route" "public" {
  count = local.public_count

  route_table_id         = element(aws_route_table.public.*.id, count.index)
  gateway_id             = var.igw_id
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [aws_route_table.public]
}

resource "aws_route" "public_ipv6" {
  count = local.public_count

  route_table_id              = element(aws_route_table.public.*.id, count.index)
  gateway_id                  = var.igw_id
  destination_ipv6_cidr_block = "::/0"
  depends_on                  = [aws_route_table.public]
}

#Module      : ROUTE TABLE ASSOCIATION PRIVATE
#Description : Provides a resource to create an association between a subnet and routing
#              table.
resource "aws_route_table_association" "public" {
  count = local.public_count

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public.*.id, count.index)
  depends_on = [
    aws_subnet.public,
    aws_route_table.public,
  ]
}

#Module      : Flow Log
#Description : Provides a VPC/Subnet/ENI Flow Log to capture IP traffic for a specific
#              network interface, subnet, or VPC. Logs are sent to a CloudWatch Log Group
#              or a S3 Bucket.
resource "aws_flow_log" "flow_log" {
  count = var.enable_flow_log == true ? 1 : 0

  log_destination      = var.s3_bucket_arn
  log_destination_type = "s3"
  traffic_type         = var.traffic_type
  subnet_id            = element(aws_subnet.public.*.id, count.index)
}

#Module      : PRIVATE SUBNET
#Description : Terraform module to create public, private and public-private subnet with
#              network acl, route table, Elastic IP, nat gateway, flow log.
resource "aws_subnet" "private" {
  count = local.private_count

  vpc_id            = var.vpc_id
  availability_zone = element(var.availability_zones, count.index)

  cidr_block = cidrsubnet(
    signum(length(var.cidr_block)) == 1 ? var.cidr_block : var.cidr_block,
    local.public_count == 0 ? ceil(log(local.private_count * 2, 2)) : ceil(log(local.public_count * 2, 2)),
    count.index
  )

  tags = merge({ "Name" = "${var.prefix}-subnet-${var.environment}-${var.application}-pr-${count.index}" },
    var.tags
  )
  lifecycle {
    # Ignore tags added by kubernetes
    ignore_changes = [
      tags,
      tags["kubernetes.io/cluster/eksctl-eks-default-analitica"],
      tags["kubernetes.io/cluster/eksctl-eks-desarrollo-analitica"],
      tags["kubernetes.io/cluster/eksctl-eks-laboratorio-analitica"],
      tags["kubernetes.io/cluster/eksctl-eks-produccion-analitica"],
      tags["kubernetes.io/role/internal-elb"],
      tags["eksctl.io"],
      tags["k8s.io"],
      tags["SubnetType"],
    ]
  }
}

#Module      : NETWORK ACL
#Description : Provides an network ACL resource. You might set up network ACLs with rules
#              similar to your security groups in order to add an additional layer of
#              security to your VPC.
resource "aws_network_acl" "private" {
  count = var.enable_acl == true && var.create_subnets_private == true && signum(length(var.private_network_acl_id)) == 0 ? 1 : 0

  vpc_id     = var.vpc_id
  subnet_ids = aws_subnet.private.*.id

  egress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  egress {
    rule_no         = 101
    action          = "allow"
    ipv6_cidr_block = "::/0"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
  }

  ingress {
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
  }

  ingress {
    rule_no         = 101
    action          = "allow"
    ipv6_cidr_block = "::/0"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
  }

  tags = merge({ "Name" = "${var.prefix}-acl-${var.environment}-${var.application}-pr-${count.index}" },
    var.tags
  )
  depends_on = [aws_subnet.private]
}

#Module      : ROUTE TABLE
#Description : Provides a resource to create a VPC routing table.
resource "aws_route_table" "private" {
  count = local.private_count

  vpc_id = var.vpc_id
  tags = merge({ "Name" = "${var.prefix}-rt-${var.environment}-${var.application}-pr-${count.index}" },
    var.tags
  )
}

#Module      : ROUTE TABLE ASSOCIATION PRIVATE
#Description : Provides a resource to create an association between a subnet and routing
#              table.
resource "aws_route_table_association" "private" {
  count = local.private_count

  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

#Module      : ROUTE
#Description : Provides a resource to create a routing table entry (a route) in a VPC
#              routing table.
resource "aws_route" "nat_gateway" {
  count = local.private_nat_gateways_count

  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.private.*.id, count.index)
  depends_on             = [aws_route_table.private]
}

#Module      : EIP
#Description : Provides an Elastic IP resource..
resource "aws_eip" "private" {
  count = local.private_nat_gateways_count

  vpc = true
  tags = merge({ "Name" = "${var.prefix}-ngw-eip-${var.environment}-${var.application}-${count.index}" },
    var.tags
  )
  lifecycle {
    create_before_destroy = true
  }
}

#Module      : NAT GATEWAY
#Description : Provides a resource to create a VPC NAT Gateway.
resource "aws_nat_gateway" "private" {
  count = local.private_nat_gateways_count

  allocation_id = element(aws_eip.private.*.id, count.index)
  subnet_id     = length(aws_subnet.public) > 0 ? element(aws_subnet.public.*.id, count.index) : element(var.public_subnet_ids, count.index)
  tags = merge({ "Name" = "${var.prefix}-nat-gateway-${var.environment}-${var.application}-${count.index}" },
    var.tags
  )
}

#Module      : Flow Log
#Description : Provides a VPC/Subnet/ENI Flow Log to capture IP traffic for a specific
#              network interface, subnet, or VPC. Logs are sent to a CloudWatch Log Group
#              or a S3 Bucket.
resource "aws_flow_log" "private_subnet_flow_log" {
  count                = var.enable_flow_log == true ? 1 : 0
  log_destination      = var.s3_bucket_arn
  log_destination_type = "s3"
  traffic_type         = var.traffic_type
  subnet_id            = element(aws_subnet.private.*.id, count.index)
}