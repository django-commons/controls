# GitHub Membership Resource
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/membership

resource "github_membership" "this" {
  for_each = local.users

  role     = each.value
  username = each.key
}

# Github Organization Security Manager Resource
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/organization_security_manager

resource "github_organization_security_manager" "this" {
  team_slug = github_team.org_teams["security-team"].slug
}
# Create the organization teams for Django Commons.
resource "github_team" "org_teams" {
  for_each = var.organization_teams

  name        = each.key
  description = each.value.description
  privacy     = each.value.privacy
}

resource "github_team_members" "org_team_members" {
  for_each = var.organization_teams

  team_id = github_team.org_teams[each.key].id

  dynamic "members" {
    for_each = each.value.members

    content {
      # members here references the dynamic name, not the looped entity.
      username = members.value
      role     = "member"
    }
  }

  # Maintainer here means the maintainer role for the team.
  # It's not a maintainer of the repo.
  dynamic "members" {
    for_each = each.value.maintainers

    content {
      # members here references the dynamic name, not the looped entity.
      username = members.value
      role     = "maintainer"
    }
  }
}
