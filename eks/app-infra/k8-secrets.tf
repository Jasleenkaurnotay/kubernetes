resource "kubernetes_secret_v1" "rds_secret" {
    metadata {
      name = "rds-secret"
      namespace = kubernetes_namespace_v1.k8_namespace.metadata[0].name
    }

    data = {
      # 1. Referece the Secret ARN/Name from rds.tf
      secret_arn = aws_secretsmanager_secret.rds_pass.arn

      #2. Reference the exact connection string value from rds.tf
      connection_string = aws_secretsmanager_secret_version.rds_pass_value.secret_string
    }
    
    type = "Opaque"
}