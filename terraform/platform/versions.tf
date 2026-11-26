terraform {
  required_version = ">= 1.10.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.59, < 7.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.4"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.3"
    }
  }
}