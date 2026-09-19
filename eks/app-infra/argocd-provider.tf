data "kubernetes_secret_v1" "argo_admin_scrt" {
    metadata {
      name = "argocd-initial-admin-secret"
      namespace = "argocd"
    }
}

provider "argocd" {
  server_addr = var.argo_route53_domain_name
  username = "admin"
  password = data.kubernetes_secret_v1.argo_admin_scrt.data["password"]
  grpc_web = true
}