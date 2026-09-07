# Query VPC ID of existing VPC
data "aws_vpc" "eks_vpc_id" {
    filter {
      name = "tag:ProjectName"
      values = [var.vpc_tag_value]
    }
}

# Create the helm_release
resource "helm_release" "lbc_helm_release" {
  name = "${var.project_name}-lbc-helm-release"
  repository = "https://aws.github.io/eks-charts"
  chart = "aws-load-balancer-controller"
  version = "1.17.1"
  cleanup_on_fail = true
  description = "Helm releaase for LB deployment on EKS cluster"
  namespace = "kube-system"
  values = 
  wait = true
  set {
    name = "clusterName"
    value = var.eks_cluster_name
  }

  set {
    name = "region"
    value = var.aws_region
  }

  set {
    name = "vpcId"
    value = data.aws_vpc.eks_vpc_id.id
  }


}



clusterName → var.eks_cluster_name
vpcId → data.aws_vpc.eks_vpc_id.id
region → probably a literal or a var
serviceAccount.annotations["eks.amazonaws.com/role-arn"] → aws_iam_role.lbc_role.arn