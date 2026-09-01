resource "kubernetes_deployment_v1" "fe_deployment" {
    metadata {
      name = "fe-deployment"
      namespace = kubernetes_namespace_v1.k8_namespace.metadata[0].name
      labels = {
        app = var.frontend_pod_label
      }
    }

    spec {
      replicas = 2
      selector {
        match_labels = {
          app = var.frontend_pod_label
        }
      }

      template {
        metadata {
          labels = {
            app = var.frontend_pod_label
          }
        }

        spec {
          container {
            image = 
          }
        }
      }
    }
  
}