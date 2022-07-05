data "kubectl_path_documents" "manifests" {
  pattern = "./deploy/*.yaml"
}

resource "kubectl_manifest" "manifest" {
  for_each   = data.kubectl_path_documents.manifests.manifests
  yaml_body  = each.value
  depends_on = [module.eks.cluster_addons]
}
