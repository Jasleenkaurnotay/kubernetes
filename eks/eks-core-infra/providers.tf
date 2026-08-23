provider "aws" {
  region = "us-east-1"

  # Automatically apply these tags to every resource managed by this block
  default_tags {
    tags = {
        Environment = "Development"
        ManagedBy = "Terraform"
        ProjectName = "EKSInfra"
    }
  }
}