# Query existing EKS cluster endpoint
data "aws_eks_cluster" "cluster_name" {
  name = var.eks_cluster_name
}

# configuring the Helm provider authentication
provider "helm" {
    kubernetes = {
      host = data.aws_eks_cluster.cluster_name.endpoint
      cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster_name.certificate_authority[0].data)

      exec = {
        api_version = "client.authentication.k8s.io/v1beta1"
        args        = ["eks", "get-token", "--cluster-name", var.eks_cluster_name]
        command     = "aws"
      }

    }
}
