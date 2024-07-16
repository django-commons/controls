# Required Providers
# https://www.terraform.io/docs/language/providers/requirements.html#requiring-providers

terraform {
  required_providers {
    github = {
      source = "integrations/github"
    }

    # Random Provider
    # https://registry.terraform.io/providers/hashicorp/random/latest/docs

    random = {
      source = "hashicorp/random"
    }

    # Time Provider
    # https://registry.terraform.io/providers/hashicorp/time/latest/docs

    time = {
      source = "hashicorp/time"
    }
  }
}

# Github Provider
# https://registry.terraform.io/providers/integrations/github/latest/docs

provider "github" {
  owner = "django-commons"
  token = var.github_token
}

# Github Actions Secret Resource
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_organization_secret

resource "github_actions_organization_secret" "this" {

  # Ensure GitHub Actions secrets are encrypted
  # checkov:skip=CKV_GIT_4: We are passing the secret from the random_password resource which is sensitive by default
  # and not checking in any plain text values. State is always secured.

  for_each = var.organization_secrets

  plaintext_value = random_password.this[each.key].result
  secret_name     = each.key
  visibility      = each.value.visibility
}

# Github Branch Protection Resource
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection
#
# resource "github_branch_protection" "this" {
#
#   # GitHub pull requests should require at least 2 approvals
#   # checkov:skip=CKV_GIT_5: 1 approval is reasonable for a small team
#   for_each = local.branch_protections
#
#   enforce_admins                  = false
#   pattern                         = "main"
#   repository_id                   = github_repository.this[each.key].name
#   require_conversation_resolution = true
#   required_linear_history         = true
#   require_signed_commits          = true
#
#   required_pull_request_reviews {
#     dismiss_stale_reviews           = true
#     require_code_owner_reviews      = true
#     required_approving_review_count = 1
#   }
#
#   required_status_checks {
#     contexts = each.value.required_status_checks_contexts
#     strict   = true
#   }
#
#   restrict_pushes {
#     push_allowances = each.value.push_allowances
#   }
# }

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
  team_slug = github_team.parents["security-team"].slug
}

# Github Repository Resource
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository

resource "github_repository" "this" {

  # Ensure GitHub repository is Private
  # checkov:skip=CKV_GIT_1: Public is ok for us since we are an open source project

  for_each = var.repositories

  allow_auto_merge            = each.value.allow_auto_merge
  allow_merge_commit          = each.value.allow_merge_commit
  allow_rebase_merge          = each.value.allow_rebase_merge
  allow_squash_merge          = each.value.allow_squash_merge
  allow_update_branch         = each.value.allow_update_branch
  archive_on_destroy          = true
  delete_branch_on_merge      = true
  description                 = each.value.description
  has_downloads               = each.value.has_downloads
  has_discussions             = each.value.has_discussions
  has_issues                  = true
  has_projects                = true
  has_wiki                    = false
  is_template                 = each.value.is_template
  name                        = each.key
  squash_merge_commit_message = "BLANK"
  squash_merge_commit_title   = "PR_TITLE"
  topics                      = each.value.topics
  visibility                  = each.value.visibility
  vulnerability_alerts        = false

  dynamic "template" {
    for_each = each.value.template != null ? [each.value.template] : []

    content {
      owner      = "django-commons"
      repository = template.value
    }
  }
}

# GitHub Repository File Resource
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file
#
# resource "github_repository_file" "security_policy" {
#   for_each = var.repositories
#
#   branch              = "main"
#   content = templatefile("${path.module}/markdown/SECURITY.md.tpl", { repository = each.key })
#   file                = "SECURITY.md"
#   repository          = each.key
#   commit_message      = "Update SECURITY.md"
#   commit_author       = "Open Source Infrastructure as Code Service Account"
#   commit_email        = "github-sa@osinfra.io"
#   overwrite_on_create = true
#
#   depends_on = [
#     github_branch_protection.this
#   ]
# }


# Github Team Resource
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team

# If you need to import a team, you can do so with the following command:
# terraform import github_team.this\[\"google-cloud-platform\"\] <team_id>

# To get the team ids, you can run the following curl command with a token that has the read:org scope against your own organization.
# curl -H "Authorization: token $GITHUB_READ_ORG_TOKEN" https://api.github.com/orgs/osinfra-io/teams

resource "github_team" "parents" {
  for_each = var.team_parents

  name        = each.key
  description = each.value.description
  privacy     = each.value.privacy
}

resource "github_team" "children" {
  for_each = var.team_children

  description    = each.value.description
  name           = each.key
  parent_team_id = github_team.parents[each.value.parent_team_key].id
  privacy        = github_team.parents[each.value.parent_team_key].privacy
}

# GitHub Team Membership Resource
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_members

resource "github_team_members" "parents" {
  for_each = var.team_parents

  team_id = github_team.parents[each.key].id

  dynamic "members" {
    for_each = each.value.members

    content {
      username = members.value
      role     = "member"
    }
  }

  dynamic "members" {
    for_each = each.value.maintainers

    content {
      username = members.value
      role     = "maintainer"
    }
  }
}

resource "github_team_members" "children" {
  for_each = var.team_children

  team_id = github_team.children[each.key].id

  dynamic "members" {
    for_each = each.value.members

    content {
      username = members.value
      role     = "member"
    }
  }

  dynamic "members" {
    for_each = each.value.maintainers

    content {
      username = members.value
      role     = "maintainer"
    }
  }
}

# Github Team Repository Resource
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_repository

resource "github_team_repository" "children" {
  for_each = local.child_team_repositories

  team_id    = github_team.children[each.value.team_child].id
  repository = each.value.repository
  permission = each.value.permission
}

resource "github_team_repository" "parents" {
  for_each = local.parent_team_repositories

  team_id    = github_team.parents[each.value.team_parent].id
  repository = each.value.repository
  permission = each.value.permission
}

# GitHub Team Settings Resource
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_settings

resource "github_team_settings" "this" {
  for_each = local.review_request_delegations

  review_request_delegation {
    algorithm    = "LOAD_BALANCE"
    member_count = 2
    notify       = false
  }

  team_id = github_team.parents[each.key].id
}

# Random Password Resource
# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password

resource "random_password" "this" {
  for_each = var.organization_secrets
  length   = 32
  special  = false

  keepers = {
    rotation_time = time_rotating.this.rotation_rfc3339
  }
}

# Time Rotating Resource
# https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/rotating

resource "time_rotating" "this" {
  rotation_days = 5
}