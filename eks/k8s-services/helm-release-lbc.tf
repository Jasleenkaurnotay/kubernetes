# Query VPC ID of existing VPC
data "aws_vpc" "eks_vpc_id" {
    filter {
      name = "tag:ProjectName"
      values = [var.vpc_tag_value]
    }
}

# Create the helm_release for LBC
resource "helm_release" "lbc_helm_release" {
  name = "${var.project_name}-lbc-helm-release"
  repository = "https://aws.github.io/eks-charts"
  chart = "aws-load-balancer-controller"
  version = "1.17.1"
  cleanup_on_fail = true
  description = "Helm releaase for LB deployment on EKS cluster"
  namespace = "kube-system"
  wait = true
  values = [ yamlencode({
    clusterName = var.eks_cluster_name
    region = var.aws_region
    vpcId = data.aws_vpc.eks_vpc_id.id
    serviceAccount = {
      annotations = {
        "eks.amazonaws.com/role-arn" = aws_iam_role.lbc_role.arn
      }
    }
  }) ]
}