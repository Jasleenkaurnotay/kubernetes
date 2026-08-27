output "ecr_repo_url" {
    value = { for k,v in aws_ecr_repository.ecr_repos : k => v.repository_url }
}

output "oidc_iam_role" {
    value = aws_iam_role.gh_oidc_role.arn
    description = "Name of IAM role meant for OIDC authentication"
}