resource "kubernetes_config_map_v1" "backend_config_map" {
    metadata {
      name = "backend-configmap"
    }

    data = {
      FLASK_DEBUG = var.flask_debug
      ALLOWED_ORIGINS = 
      DB_HOST = aws_db_instance.rds.address
      DB_PORT = aws_db_instance.rds.port
      DB_NAME = aws_db_instance.rds.db_name
    }
  
}