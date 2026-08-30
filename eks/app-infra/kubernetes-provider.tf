# Query exisitng AWS EKS cluster
data "aws_eks_cluster" "eks_cluster_info" {
    name = var.eks_cluster_name
}

# Get an authentication token to communicate with an EKS cluster
# Uses IAM credentials from the AWS provider to generate a temporary token that is compatible with AWS IAM Authenticator authentication. This can be used to authenticate to an EKS cluster or to a cluster that has the AWS IAM Authenticator server configured.

data "aws_eks_cluster_auth" "cluster_auth" {
    name = data.aws_eks_cluster.eks_cluster_info.name
}

provider "kubernetes" {
    host = data.aws_eks_cluster.eks_cluster_info.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster_info.certificate_authority[0].data)
    token = data.aws_eks_cluster_auth.cluster_auth.token  
}
