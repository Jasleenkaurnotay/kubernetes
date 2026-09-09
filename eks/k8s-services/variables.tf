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

variable "k8_svc_namespace" {
    description = "Enter the name of the kubernetes application namespace"
    type = string  
}

variable "k8_be_svc_name" {
    description = "Enter the kubernetes service name of the application's backend svc"
    type = string
}

variable "k8_be_svc_port" {
    description = "Enter the port on which the backend kubernetes service accepts requests"
    type = number  
}

variable "k8_fe_svc_name" {
    description = "Enter the kubernetes service name of the application's frontend svc"
    type = string
}

variable "k8_fe_svc_port" {
    description = "Enter the port on which the frontend kubernetes service accepts requests"
    type = number  
}