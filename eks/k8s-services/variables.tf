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

variable "domain_name" {
    description = "Enter the domain name the Route 53 hosted zone is created for"
    type = string  
}

variable "cert_domain_name" {
    description = "Enter the domain name the ACM certificate is issued to"
    type = string  
}

variable "route53_record_name" {
    description = "Enter Route53 record to which you want to map the ALB"
    type = string  
}

variable "argo_route53_domain_name" {
    description = "Enter the Route53 domain name mapped to the ArgoCD ALB"
    type = string
}

variable "argo_release_name" {
    description = "Enter the release name of the argocd helm chart version"
    type = string
}