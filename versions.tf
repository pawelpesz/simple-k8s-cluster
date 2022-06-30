terraform {
  required_version = "~> 1.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.20"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
  }
  cloud {
    # organization from TF_CLOUD_ORGANIZATION
    workspaces {
      name = "simple-k8s-cluster"
    }
  }
}
