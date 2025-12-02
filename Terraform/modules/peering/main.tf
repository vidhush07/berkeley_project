resource "aws_vpc_peering_connection" "peer" {
  vpc_id        = var.vpc_id_1
  peer_vpc_id   = var.vpc_id_2
  auto_accept   = true   
}

resource "aws_vpc_peering_connection_accepter" "peer_accept" {
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true

}

resource "aws_route" "route_to_vpc1" {
  route_table_id            = var.route_table_vpc_id_1
  destination_cidr_block    = var.cidr_block_vpc_id_2
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

resource "aws_route" "route_to_vpc2" {
  route_table_id            = var.route_table_vpc_id_2
  destination_cidr_block    = var.cidr_block_vpc_id_1
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}



