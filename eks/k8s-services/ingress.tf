resource "kubernetes_ingress_v1" "eks_ingress" {
    metadata {
      namespace = var.k8_svc_namespace
      name = "${var.eks_cluster_name}-ingress"
      annotations = {
      "alb.ingress.kubernetes.io/scheme"           = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"      = "ip"
      "alb.ingress.kubernetes.io/healthcheck-path" = "/"
      "alb.ingress.kubernetes.io/tags" = "Project=k8s-services,ManagedBy=Terraform"
      "alb.ingress.kubernetes.io/certificate-arn" = data.aws_acm_certificate.issued_https_cert.arn
      "alb.ingress.kubernetes.io/listen-ports" = jsonencode([
        { "HTTP" : 80 },
        { "HTTPS" : 443 }
      ])
      "alb.ingress.kubernetes.io/ssl-redirect" = "443"

      #-----Ingress Grouping Configuration-----
      "alb.ingress.kubernetes.io/group.name" = "${var.project_name}-${var.eks_cluster_name}-alb-group"
      }
    }

      spec {
        ingress_class_name = "alb"

        rule {
            host = var.route53_record_name
            
            http {
                path {
                    path = "/api"
                    path_type = "Prefix"

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
                    path_type = "Prefix"

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

# Create Ingress object for ArgoCD server
resource "kubernetes_ingress_v1" "argocd_ingress" {
    metadata {
      namespace = kubernetes_namespace_v1.k8_argocd_namespace.metadata[0].name
      name = "${var.eks_cluster_name}-argocd-ingress"
      annotations = {
      "alb.ingress.kubernetes.io/scheme"           = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"      = "ip"
      "alb.ingress.kubernetes.io/healthcheck-path" = "/healthz"
      "alb.ingress.kubernetes.io/tags" = "Project=argocd-k8s-services,ManagedBy=Terraform"
      "alb.ingress.kubernetes.io/certificate-arn" = data.aws_acm_certificate.issued_https_cert.arn
      "alb.ingress.kubernetes.io/listen-ports" = jsonencode([
        { "HTTPS" : 443 }
      ])
      #-----Ingress Grouping Configuration-----
      "alb.ingress.kubernetes.io/group.name" = "${var.project_name}-${var.eks_cluster_name}-alb-group"
      }
    }

      spec {
        ingress_class_name = "alb"

        rule {
            host = var.argo_route53_domain_name
            
            http {
                path {
                    path = "/"
                    path_type = "Prefix"

                    backend {
                        service {
                            name = "${var.argo_release_name}-argocd-server"
                            port {
                                number = 80
                            }
                        }
                    }
                }
            }
        }

      }
    depends_on = [ helm_release.argocd_helm_release ]
}

# Data block to query the shared ALB created by the Ingress controller, when either Ingress object reconciles
data "aws_lb" "shared_alb" {
    tags = {
      "ingress.k8s.aws/stack" = "${var.project_name}-${var.eks_cluster_name}-alb-group"
    }
    depends_on = [ kubernetes_ingress_v1.argocd_ingress, kubernetes_ingress_v1.eks_ingress ]
}