resource "aws_subnet" "private" {
  for_each = {
    for idx, cidr in var.private_cidrs :
    idx => cidr
  }

  vpc_id            = var.vpc_id
  cidr_block        = each.value
  availability_zone = var.availability_zones[each.key]

  tags = {
    Name = "private-subnet-${each.key}"
  }
}