data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = var.state_bucket
    key    = var.network_state_key
    region = var.state_region
  }
}

data "aws_vpc" "peer" {
  id = var.peer_vpc_id
}

data "aws_vpc" "eks" {
  id = data.terraform_remote_state.network.outputs.vpc_id
}
