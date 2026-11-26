variable "kubeconfig_path" {
  description = "Dedicated kubeconfig for the target EKS cluster"
  type        = string
  default     = "~/.kube/eks-config"
}

variable "autoscaler_chart_version" {
  description = "Cluster Autoscaler Helm chart version"
  type        = string
  default     = "9.60.0"
}

variable "autoscaler_image_tag" {
  description = "Verified Kubernetes 1.37-compatible autoscaler image tag"
  type        = string
  default     = "v1.37.0"
}

variable "enable_cluster_autoscaler" {
  description = "Deploy Cluster Autoscaler when a compatible release is available"
  type        = bool
  default     = true
}

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

variable "cluster_state_key" {
  type    = string
  default = "eks/cluster/terraform.tfstate"
}
