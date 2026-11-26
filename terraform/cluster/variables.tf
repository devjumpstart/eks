variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "eks-dev-cluster"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.37"
}

variable "node_instance_type" {
  description = "EC2 instance type for EKS workers"
  type        = string
  default     = "t3.medium"
}

variable "admin_public_cidr" {
  description = "Public IPv4 CIDR allowed to access the EKS API"
  type        = string
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

variable "state_bucket" {
  description = "S3 bucket containing Terraform state"
  type        = string
}

variable "state_region" {
  description = "AWS region of the Terraform state bucket"
  type        = string
  default     = "ca-central-1"
}

variable "network_state_key" {
  description = "S3 object key for the network Terraform state"
  type        = string
  default     = "eks/network/terraform.tfstate"
}
