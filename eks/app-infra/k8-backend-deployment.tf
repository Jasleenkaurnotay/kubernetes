resource "kubernetes_deployment_v1" "be_deployment" {
    metadata {
      name = "be-deployment"
      namespace = kubernetes_namespace_v1.k8_namespace.metadata[0].name
      labels = {
        app = var.backend_pod_label
      }
    }

    spec {
      replicas = 2
      selector {
        match_labels = {
          app = var.backend_pod_label
        }
      }

      template {
        metadata {
          labels = {
            app = var.backend_pod_label
          }
        }

        spec {
          container {
            image = "${aws_ecr_repository.ecr_repos[var.backend_svc_name].repository_url}:${var.backend_image_tag}"
            name = "backend-container"
            port {
              protocol = "TCP"
              container_port = 8000
            }
            liveness_probe {
              http_get {
                path = "/"
                port = 8000
              }
              initial_delay_seconds = 10
              period_seconds = 3
              success_threshold = 1
              timeout_seconds = 15
            }
            resources {
              requests = {
                memory = "100Mi"
                cpu = "0.5"
              }
              limits = {
                memory = "150Mi"
                cpu = "0.7"
              }
            }
            env_from {
              config_map_ref {
                name = kubernetes_config_map_v1.backend_config_map.metadata[0].name
              }
            }
            env_from {
              secret_ref {
                name = kubernetes_secret_v1.rds_secret.metadata[0].name
              }
            }
          }
        }
      }
    }
  
}