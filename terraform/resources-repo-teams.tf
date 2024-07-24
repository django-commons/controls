# Create the main repository team for Django Commons.
resource "github_team" "repo_team" {
  for_each = {for k, v in var.repositories : k => v if v.skip_team_creation == false}

  name        = each.key
  description = "Main team for the ${each.key} repository"
  privacy     = "closed"
}
resource "github_team_members" "repo_team_members" {
  for_each = {for k, v in var.repositories : k => v if v.skip_team_creation == false}

  team_id = github_team.repo_team[each.key].id


  dynamic "members" {
    for_each = each.value.members

    content {
      # members here references the dynamic name, not the looped entity.
      username = members.value
      role     = "member"
    }
  }
  dynamic "members" {
    for_each = each.value.committers

    content {
      # members here references the dynamic name, not the looped entity.
      username = members.value
      role     = "member"
    }
  }

  # Maintainer here means the maintainer role for the team.
  # It's not a maintainer of the repo.
  dynamic "members" {
    for_each = each.value.admins

    content {
      # members here references the dynamic name, not the looped entity.
      username = members.value
      role     = "member"
    }
  }
}
resource "github_team_repository" "repo_team_access" {
  for_each   = {for k, v in var.repositories : k => v if v.skip_team_creation == false}
  repository = each.key
  team_id    = github_team.repo_team[each.key].id
  permission = "triage"
}
# GitHub Team Settings Resource
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_settings

# This is used to enable automatic PR review requests
resource "github_team_settings" "this" {
  for_each = {for k, v in var.repositories : k => v if v.skip_team_creation == false}

  review_request_delegation {
    algorithm    = "LOAD_BALANCE"
    member_count = 2
    notify       = false
  }

  team_id = github_team.repo_team[each.key].id
}
