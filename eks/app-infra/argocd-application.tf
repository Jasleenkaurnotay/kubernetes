resource "argocd_application" "argocd_application" {
  wait = true
  metadata {
    name      = "argocd-application"
    namespace = var.k8s_argocd_namespace
  }

  spec {
    project = "default"
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace_v1.k8_namespace.metadata[0].name
    }

    sync_policy {
        automated {
            self_heal = true
            prune = true
        }
        retry {
            limit = 3
            backoff {
              duration = "5m"
              factor = 2
              max_duration = "30m"
            }
        }
    }

    source {
      repo_url        = "https://github.com/Jasleenkaurnotay/kubernetes.git"
      path = "eks/argo-k8s-manifests"
      target_revision = "gitops-deploy"
    }
  }
}