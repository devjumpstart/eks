resource "aws_route" "eks_to_peer" {
  for_each = toset(var.eks_route_table_ids)

  route_table_id            = each.value
  destination_cidr_block    = data.aws_vpc.peer.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.eks_to_peer.id
}

resource "aws_route" "peer_to_eks" {
  for_each = toset(var.peer_route_table_ids)

  route_table_id            = each.value
  destination_cidr_block    = data.aws_vpc.eks.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.eks_to_peer.id
}