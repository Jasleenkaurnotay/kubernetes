variable "svc_names" {
    description = "Enter a list of service names for which ECR repo is required"
    type = list(string)
}

variable "vpc_tag_value" {
    description = "Enter the value of the VPC tag name: ProjectName"
    type = string  
}

variable "pvt_sub_tag_value" {
    description = "Enter the value of the VPC subnet tag name: Tier"
    type = string  
}

variable "rds_name" {
    description = "Enter the name you would like to assign to the RDS server"
    type = string
}

variable "rds_db_name" {
    description = "Enter the name of the database you want the application to connect to"
    type = string
}

variable "rds_username" {
    description = "Enter the Master username for the RDS server"
    type = string  
}

variable "eks_cluster_name" {
    description = "Enter the name of the EKS cluster"
    type = string  
}

variable "flask_debug" {
    description = "Enter the value for environment variable FLASK_DEBUG"
    type = number
    default = 0  
}