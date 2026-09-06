provider "aws" {
    region = "us-east-1"

    default_tags {
        tags = {
            Environment = "Development"
            ManagedBy = "Terraform"
            ProjectName = "k8s-services"
        }
    }
}