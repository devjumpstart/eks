variable "aws_region" {
  type    = string
  default = "ca-central-1"
}

variable "aws_account_id" {
  type = string
}

variable "project" {
  type    = string
  default = "eks"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "state_bucket" {
  type = string
}

variable "state_region" {
  type    = string
  default = "ca-central-1"
}

variable "network_state_key" {
  type    = string
  default = "eks/network/terraform.tfstate"
}

variable "peer_vpc_id" {
  description = "ID of the existing VPC to peer with"
  type        = string
}

variable "eks_route_table_ids" {
  description = "EKS VPC route tables requiring peering routes"
  type        = list(string)
}

variable "peer_route_table_ids" {
  description = "Peer VPC route tables requiring peering routes"
  type        = list(string)
}