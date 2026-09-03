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
            image = "${aws_ecr_repository.ecr_repos[var.frontend_svc_name].repository_url}:${var.frontend_image_tag}"
            name = "frontend-container"
            port {
              protocol = "TCP"
              container_port = 80
            }
            liveness_probe {
              http_get {
                path = "/health"
                port = 80
              }
              initial_delay_seconds = 10
              period_seconds = 3
              success_threshold = 1
              timeout_seconds = 15
            }
            resources {
              requests = {
                memory = "50Mi"
                cpu = "50m"
              }
              limits = {
                memory = "70Mi"
                cpu = "70m"
              }
            }
          }
        }
      }
    }
  
}