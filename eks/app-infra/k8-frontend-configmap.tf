resource "kubernetes_config_map_v1" "frontend_config_map" {
    metadata {
      name = "frontend-configmap"
      namespace = kubernetes_namespace_v1.k8_namespace.metadata[0].name
    }

    data = {
      BACKEND_URL = "${kubernetes_service_v1.backend_svc.metadata[0].name}.${kubernetes_namespace_v1.k8_namespace.metadata[0].name}.svc.cluster.local:${kubernetes_service_v1.backend_svc.spec[0].port[0].port}"
      # <name>.<namespace>.svc.cluster.local:port 
    }
  
}