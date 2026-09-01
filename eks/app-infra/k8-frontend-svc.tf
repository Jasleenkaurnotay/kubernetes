resource "kubernetes_service_v1" "frontend_svc" {
    metadata {
      name = "frontend-service"
      namespace = kubernetes_namespace_v1.k8_namespace.metadata[0].name
    }
    spec {
      selector = {
        app = var.frontend_pod_label
      }
      port {
        port = 80
        target_port = 80
      }

      type = "ClusterIP"
    }
}