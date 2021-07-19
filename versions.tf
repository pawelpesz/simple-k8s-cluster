terraform {
    required_version = "~> 1.0"
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 3.50"
        }
        kubernetes = {
            source  = "hashicorp/kubernetes"
            version = "~> 2.3"
        }
    }
}