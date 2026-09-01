resource "kubernetes_service_v1" "backend_svc" {
    metadata {
      name = "backend-service"
      namespace = kubernetes_namespace_v1.k8_namespace.metadata[0].name
    }
    spec {
      selector = {
        app = var.backend_pod_label
      }
      port {
        port = 8000
        target_port = 8000
      }

      type = "ClusterIP"
    }
}