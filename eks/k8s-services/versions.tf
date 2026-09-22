terraform {
  required_version = "~> 1.15"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.28"
    }
    helm = {
        source = "hashicorp/helm"
        version = "~> 3.1"
    }
    argocd = {
      source = "argoproj-labs/argocd"
      version = "~> 7.15"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 3.1"
    }
  }

  backend "s3" {
    bucket = "mylabs-terraform-state"
    key = "k8s-services/dev/state/terraform.tfstate"
    region = "us-east-1"
    encrypt = true

    use_lockfile = true
  }
}