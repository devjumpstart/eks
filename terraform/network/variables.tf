variable "vpc_cidr" {
  description = "IPv4 CIDR block for the EKS VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
}

variable "private_subnets" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.16.0/20", "10.0.32.0/20"]
}

variable "aws_region" {
  description = "AWS region for infrastructure deployment"
  type        = string
  default     = "ca-central-1"
}

variable "aws_account_id" {
  description = "AWS account authorized for deployment"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "eks"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "single_nat_gateway" {
  description = "Use a single NAT gateway to reduce costs"
  type        = bool
  default     = true
}
