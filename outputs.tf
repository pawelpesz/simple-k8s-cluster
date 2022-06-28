locals {
  kubeconfig = yamlencode({
    apiVersion      = "v1"
    kind            = "Config"
    current-context = "terraform"
    clusters = [{
      name = module.eks.cluster_id
      cluster = {
        certificate-authority-data = module.eks.cluster_certificate_authority_data
        server                     = module.eks.cluster_endpoint
      }
    }]
    contexts = [{
      name = "terraform"
      context = {
        cluster = module.eks.cluster_id
        user    = "terraform"
      }
    }]
    users = [{
      name = "terraform"
      user = {
        token = data.aws_eks_cluster_auth.cluster.token
      }
    }]
  })
}

output "kubeconfig" {
  description = "KUBE_CONFIG"
  value       = local.kubeconfig
  sensitive   = true
}

output "kubeconfig_b64" {
  description = "KUBE_CONFIG (Base64 Encoded)"
  value       = base64encode(local.kubeconfig)
  sensitive   = true
}
