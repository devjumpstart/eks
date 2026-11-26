resource "aws_vpc_peering_connection" "eks_to_peer" {
  vpc_id      = data.aws_vpc.eks.id
  peer_vpc_id = data.aws_vpc.peer.id

  auto_accept = true

  tags = {
    Name = "${var.project}-${var.environment}-peering"
  }
}

resource "aws_vpc_peering_connection_options" "dns" {
  vpc_peering_connection_id = aws_vpc_peering_connection.eks_to_peer.id

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}
