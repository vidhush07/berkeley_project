output "vpc_id" {
  value = aws_vpc.vpc_name.id
}

output "vpc_cidrs" {
  value = aws_vpc.vpc_name.cidr_block
}