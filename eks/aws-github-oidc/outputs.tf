output "oidc_iam_role" {
    value = aws_iam_role.gh_oidc_role.arn
    description = "Name of IAM role meant for OIDC authentication"
}