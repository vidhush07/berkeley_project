output "public_subnet_ids" {
  value = [for s in aws_subnet.public : s.id]
}

output "igw_vpc_id" {
  value = aws_internet_gateway.igw.id
}

output "route_table_vpc_id" {
  value = aws_route_table.public_rt.id
}
