# Configure the OIDC provider in the AWS account
# AWS doesn't validate this for GitHub's provider — placeholder satisfies the schema
resource "aws_iam_openid_connect_provider" "gh_oidc_provider" {
    url = "https://token.actions.githubusercontent.com"

    client_id_list = [
        "sts.amazonaws.com"
    ]

    thumbprint_list = ["ffffffffffffffffffffffffffffffffffffffff"]
}

# Create IAM policy that allows github actions to assume a certain role with some permissions
# 1. Create the template for the IAM Policy
data "aws_iam_policy_document" "oidc_role_doc" {
    statement {
      actions = ["sts:AssumeRoleWithWebIdentity"]

      principals {
        type = "Federated"
        identifiers = [aws_iam_openid_connect_provider.gh_oidc_provider.arn]
      }

      condition {
        test = "StringEquals"
        values = ["sts.amazonaws.com"]
        variable = "token.actions.githubusercontent.com:aud"
      }

      condition {
        test = "StringLike"
        values = ["repo:<<<need to make this dynamic>>>>"]
        variable = "token.actions.githubusercontent.com:sub"
      }
    }
}

# 2. Create IAM role
resource "aws_iam_role" "gh_oidc_role" {
    name = "github_oidc_role"
    assume_role_policy = data.aws_iam_policy_document.oidc_role_doc.json
}

# 3. Create IAM policy to attach to this role
data "aws_iam_policy_document" "gh_oidc_policy_doc" {
    statement {
      effect = "Allow"
      actions = [
        "ecr:*"
      ]
      resources = ["*"]
    }
}

resource "aws_iam_policy" "gh_oidc_policy" {
    name = "gh-oidc-pol"
    description = "IAM policy for deployments from github actions"
    policy = data.aws_iam_policy_document.gh_oidc_policy_doc.json  
}

resource "aws_iam_role_policy_attachment" "gn_oidc_policy_attach" {
    role = aws_iam_role.gh_oidc_role.name
    policy_arn = aws_iam_policy.gh_oidc_policy.arn  
}