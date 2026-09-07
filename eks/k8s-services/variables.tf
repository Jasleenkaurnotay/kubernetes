variable "aws_region" {
    description = "Enter the name of the AWS region for the infrastructure"
    type = string
    default = "us-east-1"  
}

variable "eks_cluster_name" {
    description = "Enter the name of the EKS cluster"
    type = string  
}

variable "vpc_tag_value" {
    description = "Enter the value of the VPC tag name: ProjectName"
    type = string  
}

variable "project_name" {
    description = "Enter the name of the project relating to this deployment"
    type = string  
}