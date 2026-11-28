module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.30.2"

  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version

  # Networking - from the network Terraform state
  vpc_id     = data.terraform_remote_state.network.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.network.outputs.private_subnet_ids

  # Kubernetes API access
  endpoint_private_access      = true
  endpoint_public_access       = true
  endpoint_public_access_cidrs = [var.admin_public_cidr]

  # IAM authentication
  authentication_mode = "API"

  enable_cluster_creator_admin_permissions = true

  # Enable IRSA for Kubernetes service accounts
  enable_irsa = true

  # Protect against accidental cluster deletion
  deletion_protection = true

  # EKS provides encryption by default
  create_kms_key    = false
  encryption_config = null

  # Control plane logging
  enabled_log_types                      = ["api", "authenticator"]
  cloudwatch_log_group_retention_in_days = 7

  # AWS-managed Kubernetes add-ons
  addons = {
    coredns = {
      most_recent = false
    }

    kube-proxy = {
      most_recent = false
    }

    vpc-cni = {
      before_compute = true
      most_recent    = false
    }

    eks-pod-identity-agent = {
      before_compute = true
      most_recent    = false
    }
  }

  # Managed worker nodes
  eks_managed_node_groups = {
    general = {
      instance_types = [var.node_instance_type]
      ami_type       = "AL2023_x86_64_STANDARD"
      capacity_type  = "ON_DEMAND"

      min_size     = 1
      max_size     = 4
      desired_size = 1
    }
  }
}