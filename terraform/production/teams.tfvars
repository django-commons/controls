teams_organization = {
  "Admins" = {
    description = "django-commons administrators"
    # Use maintainers for organizational teams
    maintainers = [
      "tim-schilling",
      "williln",
      "ryancheley",
      "Stormheg",
      "cunla",
    ]
  }
  "security-team" = {
    description = "django-commons security team"
    # Use maintainers for organizational teams
    maintainers = [
      "tim-schilling",
      "matthiask"
    ]
    permission = "push"

    repositories = [
    ]
  }
}

teams_repositories = {
  "django-community-playground" = {
    description = "django-community-playground team"
    members = [
      "tim-schilling",
      "williln",
      "ryancheley",
      "Stormheg",
      "cunla",
      "priyapahwa",
    ]
    permission = "triage"

    repositories = [
      "django-commons-playground",
    ]

    review_request_delegation = true
  }

}

teams_repositories_privileged = {
  "django-community-playground-admins" = {
    description     = "django-community-playground administrators"
    parent_team_key = "django-community-playground"
    permission      = "admin"
    members = [
      "tim-schilling",
      "williln",
      "ryancheley",
      "Stormheg",
      "cunla",
    ]

    repositories = [
      "django-commons-playground",
    ]
  }
  "django-community-playground-committers" = {
    description     = "django-community-playground committers"
    parent_team_key = "django-community-playground"
    permission      = "maintain"
    members = [
      "priyapahwa",
    ]

    repositories = [
      "django-commons-playground"
    ]
  }

}
