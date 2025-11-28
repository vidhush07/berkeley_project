resource "aws_vpc" "vpc_name" {
  cidr_block = var.vpc_cidrs
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = var.vpc_name
  }
}
