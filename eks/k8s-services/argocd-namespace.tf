resource "kubernetes_namespace_v1" "k8_argocd_namespace" {
    metadata {
      name = "argocd"
    }
}