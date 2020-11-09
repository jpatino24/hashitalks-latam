#SUBNETS PUBLIC
output "public_subnet_id" {
  value       = aws_subnet.public.*.id
  description = "The ID of the subnet."
}
output "public_subnet_cidrs" {
  value       = aws_subnet.public.*.cidr_block
  description = "CIDR blocks of the created public subnets."
}
output "public_route_tables_id" {
  value       = aws_route_table.public.*.id
  description = "The ID of the routing table."
}
output "public_subnet_tags" {
  value = aws_subnet.public.*.tags
}
#SUBNETS PRIVATE
output "private_subnet_id" {
  value       = aws_subnet.private.*.id
  description = "The ID of the private subnet."
}
output "private_subnet_cidrs" {
  value       = aws_subnet.private.*.cidr_block
  description = "CIDR blocks of the created private subnets."
}
output "private_route_tables_id" {
  value       = aws_route_table.private.*.id
  description = "The ID of the routing table."
}
output "ngw_id" {
  value = aws_nat_gateway.private.*.id
}
output "private_subnet_tags" {
  value = aws_subnet.private.*.tags
}








