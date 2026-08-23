variable "vpc_name" {
    type = string
}

variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "pub_sub_cidr" {
    type = list(string)
    description = "Specify two public subnet cidrs"
}

variable "pvt_sub_cidr" {
    type = list(string)
    description = "Specify two private subnet cidrs"
}

#### EKS variables
variable "eks_cluster_name" {
    type = string
    description = "Specify the name of the EKS cluster"
}

variable "k8_version" {
    type = string
    description = "Specify the version of Kubernetes"
}