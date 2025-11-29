resource "aws_subnet" "public" {
  for_each = length(var.public_cidrs) > 0 ? {
    for idx, cidr in var.public_cidrs :
    idx => cidr
  } : {}

  vpc_id                  = var.vpc_id
  cidr_block              = each.value
  availability_zone       = var.availability_zones[each.key]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${each.key}"
  }
}

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id

  tags = {
    Name = "public-route-table"
  }
}

# Route to Internet
resource "aws_route" "public_internet_route" {
  count = length(var.public_cidrs) == null ? 1:0

  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internetgateway_id
}

resource "aws_route_table_association" "public_assoc" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}
