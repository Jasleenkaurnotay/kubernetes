resource "kubernetes_ingress_v1" "eks_ingress" {
    metadata {
      namespace = var.k8_svc_namespace
      name = "${var.eks_cluster_name}-ingress"
      annotations = {
      "alb.ingress.kubernetes.io/scheme"           = # ...
      "alb.ingress.kubernetes.io/target-type"      = # ...
      "alb.ingress.kubernetes.io/healthcheck-path" = # ...
    }
    }

      spec {
        ingress_class_name = "alb"

        rule {
            http {
                path {
                    path = "/api"

                    backend {
                        service {
                            name = var.k8_be_svc_name
                            port {
                                number = var.k8_be_svc_port
                            }
                        }
                    }
                }
                path {
                    path = "/"

                    backend {
                        service {
                            name = var.k8_fe_svc_name
                            port {
                                number = var.k8_fe_svc_port
                            }
                        }
                    }
                }
            }
        }

      }  
}




