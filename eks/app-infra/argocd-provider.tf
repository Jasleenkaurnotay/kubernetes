data "kubernetes_secret_v1" "argo_admin_scrt" {
    metadata {
      name = "argocd-initial-admin-secret"
      namespace = "argocd"
    }
}