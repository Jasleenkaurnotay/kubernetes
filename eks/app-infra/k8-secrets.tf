resource "kubernetes_secret_v1" "rds_secret" {
    metadata {
      name = "devopsquiz-app-secrets"
      namespace = kubernetes_namespace_v1.k8_namespace.metadata[0].name
    }

    data = {
      # 1. Reference the exact connection string value from rds.tf
      DATABASE_URL = aws_secretsmanager_secret_version.rds_pass_value.secret_string

      SECRET_KEY = random_password.backend_secret_key.result

      DB_PASSWORD = aws_db_instance.rds.password

      DB_USERNAME = aws_db_instance.rds.username
    }
    
    type = "Opaque"
}