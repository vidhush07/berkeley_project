resource "aws_eip" "nat_eip" {
  domain   = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.subnet_public_id
}

resource "aws_route" "private_route_nat" {
  route_table_id         = var.route_table_private_id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = var.subnet_private_id
  route_table_id = var.route_table_private_id
}

resource "aws_route" "public_route_igw" {
  route_table_id         = var.route_table_public_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_vpc_id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = var.subnet_public_id
  route_table_id = var.route_table_public_id
}
