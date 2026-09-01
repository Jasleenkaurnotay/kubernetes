resource "kubernetes_config_map_v1" "backend_config_map" {
    metadata {
      name = "backend-configmap"
      namespace = kubernetes_namespace_v1.k8_namespace.metadata[0].name
    }

    data = {
      FLASK_DEBUG = var.flask_debug
      ALLOWED_ORIGINS = "*"  ## Temporary, to be updated once the frontend URL is created
      DB_HOST = aws_db_instance.rds.address
      DB_PORT = aws_db_instance.rds.port
      DB_NAME = aws_db_instance.rds.db_name
    }
  
}