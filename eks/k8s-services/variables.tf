variable "eks_cluster_name" {
    description = "Enter the name of the EKS cluster"
    type = string  
}

variable "vpc_tag_value" {
    description = "Enter the value of the VPC tag name: ProjectName"
    type = string  
}