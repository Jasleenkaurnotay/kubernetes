# 1. write aws_ecr_repository resources for the two images
# 2. Add am aws_ssm_paramter per repo to store the repository_url
# 3. Add ssm:GetParameter permissions to the gh_oidc_policy
# 4. in the workflow, add an aws ssm get-parameter step before the build step to capture the output into an env_var

resource "aws_ecr_repository" "ecr_repos" {
  for_each = toset(var.svc_names)
  name = each.key
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ssm_parameter" "ecr_repo_param" {
  for_each = toset(var.svc_names)
  name = "${each.key}-ecr-url"
  type = "String"
  value = aws_ecr_repository.ecr_repos[each.key].repository_url
}