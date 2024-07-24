# Local Values
# https://www.terraform.io/language/values/locals

locals {

  admins = {
    for user in var.admins : user => "admin"
  }

  branch_protections = {
    for repository_key, repository in var.repositories : repository_key => repository
    if repository.enable_branch_protection
  }

  privileged_repository_team_permissions = {

    for repository in flatten([
      for team_key, team in var.teams_repositories_privileged : [
        for repository in team.repositories : {
          team_child = team_key
          repository = repository
          permission = team.permission
        }
      ]
    ]) : "${repository.team_child}-${repository.repository}" => repository
  }


  members = {
    for user in var.members : user => "member"
  }

  repository_team_permissions = {

    for repository in flatten([
      for team_key, team in var.teams_repositories : [
        for repository in team.repositories : {
          team_parent = team_key
          repository  = repository
          permission  = team.permission
        }
      ]
    ]) : "${repository.team_parent}-${repository.repository}" => repository
  }

  review_request_delegations = {
    for team_key, team in var.teams_repositories : team_key => team
    if team.review_request_delegation
  }

  users = merge(local.admins, local.members)
}
