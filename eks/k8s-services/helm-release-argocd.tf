# Create the helm_release for ArgoCD
resource "helm_release" "argocd_helm_release" {
  name = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart = "argo-cd"
  version = "10.9.1" # Use latest version
  namespace = kubernetes_namespace_v1.k8_argocd_namespace.metadata[0].name
  values = [yamlencode({
    server = {
      ingress = {
        enabled = false
      }
      service = {
        type = "ClusterIP"
      }
    }
    configs = {
      params = {
        "server.insecure" = true
      }
    }
  })]
}