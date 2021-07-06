provider "aws" {
    region = var.region
	access_key = var.aws_access_key_id
	secret_key = var.aws_secret_access_key
}

data "aws_eks_cluster_auth" "cluster" {
    name = module.eks.cluster_id
}

provider "kubernetes" {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.cluster.token
}
