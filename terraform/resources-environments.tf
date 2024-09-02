import {
  for_each = {for k, v in var.repositories : k => v if v.is_django_commons_repo == false}

  id = "${each.key}:pypi"
  to = github_repository_environment.pypi[each.key]
}

resource "github_repository_environment" "pypi" {
  for_each = {for k, v in var.repositories : k => v if v.is_django_commons_repo == false}

  environment         = "pypi"
  repository          = each.key
  prevent_self_review = true
  reviewers {
    teams = [github_team.repo_admin_team[each.key].id]
  }
  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = false
  }
}

resource "github_repository_environment" "testpypi" {
  for_each = {for k, v in var.repositories : k => v if v.is_django_commons_repo == false}

  environment         = "testpypi"
  repository          = each.key
  prevent_self_review = true

  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = false
  }
}