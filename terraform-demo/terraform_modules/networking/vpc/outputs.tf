output "main_vpc_id" {
  value = aws_vpc.main_vpc.*.id
}
output "main_cidr_block" {
  value = aws_vpc.main_vpc.*.cidr_block
}
output "acl_id" {
  value = aws_default_network_acl.acl_vpc.*.id
}
output "igw_id" {
  value = aws_internet_gateway.internet_gateway.*.id
}
output "main_route_table_id" {
  value = aws_vpc.main_vpc.*.main_route_table_id
}
output "main_vpc_tags" {
  value = aws_vpc.main_vpc.*.tags
}
