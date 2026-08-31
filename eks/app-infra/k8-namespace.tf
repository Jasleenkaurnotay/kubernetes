resource "kubernetes_namespace_v1" "k8_namespace" {
    metadata {
      name = "devopsquiz-app"
    }
}