terraform {
  required_version = "~> 1.15"

  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 6.28"
    }
  }

  backend "s3" {
    bucket = "mylabs-terraform-state"
    key = "aws-github-oidc/dev/state/terraform.tfstate"
    region = "us-east-1"
    encrypt = true

    use_lockfile = true
  }
}