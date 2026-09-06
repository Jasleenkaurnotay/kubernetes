# Look up the existing OIDC provider for EKS (created automatically by the EKS module)
data "aws_iam_openid_connect_provider" "eks_oidc_provider" {
    url = data.aws_eks_cluster.cluster_name.identity[0].oidc[0].issuer
}

# Create IAM Trust policy: who can assume this role
data "aws_iam_policy_document" "lbc_assume_role" {
    statement {
      actions = ["sts:AssumeRoleWithWebIdentity"]
      effect = "Allow"

      principals {
        type = "Federated"
        identifiers = [data.aws_iam_openid_connect_provider.eks_oidc_provider.arn]
      }

      condition {
        test = "StringEquals"
        variable = "${replace(data.aws_iam_openid_connect_provider.eks_oidc_provider.url, "https://", "")}:sub"
        values = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
      }

      condition {
        test = "StringEquals"
        variable = "${replace(data.aws_iam_openid_connect_provider.eks_oidc_provider.url, "https://", "")}:aud"
        values = ["sts.amazonaws.com"]
      }
    }
}

# The IAM role itself
resource "aws_iam_role" "lbc_role" {
    name = "${var.eks_cluster_name}-aws-load-balancer-controller"
    assume_role_policy = data.aws_iam_policy_document.lbc_assume_role.json  
}

# Permissions policy: what this role can do (from AWS's downlaoded JSON file)
resource "aws_iam_policy" "lbc_policy" {
    name = "${var.eks_cluster_name}-aws-lbc-policy"
    policy = file("iam-policy.json")  
}

# Attach permissions to the role
resource "aws_iam_role_policy_attachment" "lbc_role_pol_attach" {
    role = aws_iam_role.lbc_role.name
    policy_arn = aws_iam_policy.lbc_policy.arn  
}