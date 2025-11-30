output "vpc_id" {
  value = aws_vpc.vpc_name.id
}

output "vpc_cidrs" {
  value = aws_vpc.vpc_name.cidr_block
}

output "vpc_route_table_id" {
  value = aws_vpc.vpc_name.main_route_table_id
}