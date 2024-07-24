# Define the admin team for each repository
resource "github_team" "repo_admin_team" {
  for_each = {for k, v in var.repositories : k => v if v.skip_team_creation == false}

  parent_team_id = github_team.repo_team[each.key].id
  name           = "${each.key}-admins"
  description    = "Admin team for the ${each.key} repository"
  privacy        = "closed"
}

resource "github_team_members" "repo_admin_members" {
  for_each = {for k, v in var.repositories : k => v if v.skip_team_creation == false}

  team_id = github_team.repo_admin_team[each.key].id

  dynamic "members" {
    for_each = each.value.admins

    content {
      # members here references the dynamic name, not the looped entity.
      username = members.value
      role     = "maintainer"
    }
  }
}

resource "github_team_repository" "repo_admin_team_access" {
  for_each   = {for k, v in var.repositories : k => v if v.skip_team_creation == false}
  repository = each.key
  team_id    = github_team.repo_admin_team[each.key].id
  permission = "admin"
}