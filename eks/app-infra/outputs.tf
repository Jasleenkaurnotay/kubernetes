output "ecr_repo_url" {
    value = { for k,v in aws_ecr_repository.ecr_repos : k => v.repository_url }
}