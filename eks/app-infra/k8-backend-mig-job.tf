resource "kubernetes_job_v1" "backend_mig_job" {
  metadata {
    name      = "${var.backend_svc_name}-mig-job"
    namespace = kubernetes_namespace_v1.k8_namespace.metadata[0].name
  }

  spec {
    backoff_limit = 2

    template {
      metadata {
        name = "${var.backend_svc_name}-mig-job"
      }
      spec {
        container {
          name    = "migration-container"
          image   = "${aws_ecr_repository.ecr_repos[var.backend_svc_name].repository_url}:${var.backend_image_tag}"
          command = ["./migrate.sh"]

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
        restart_policy = "OnFailure"
      }
    }
  }

  wait_for_completion = true

  timeouts {
    create = "5m"
  }
}