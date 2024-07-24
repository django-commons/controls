teams_organization = {
  "Admins" = {
    description = "django-commons administrators"
    maintainers = [
      "tim-schilling",
      "williln",
      "ryancheley",
      "Stormheg",
      "cunla",
    ]
    members = null
  }
  "security-team" = {
    description = "django-commons security team"
    maintainers = [
      "tim-schilling",
      "matthiask"
    ]
    members = []
    permission = "push"

    repositories = [
    ]
  }
}

teams_repositories = {
  "django-community-playground" = {
    description = "django-community-playground team"
    maintainers = [
      "tim-schilling",
      "williln",
      "ryancheley",
      "Stormheg",
      "cunla",
    ]
    members = [
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
    maintainers = [
      "tim-schilling",
      "williln",
      "ryancheley",
      "Stormheg",
      "cunla",
    ]
    members = null

    repositories = [
      "django-commons-playground",
    ]
  }
  "django-community-playground-committers" = {
    description     = "django-community-playground committers"
    parent_team_key = "django-community-playground"
    permission      = "maintain"
    maintainers = [
      "tim-schilling",
      "williln",
      "ryancheley",
      "Stormheg",
      "cunla",
    ]
    members = [
      "priyapahwa",
    ]

    repositories = [
      "django-commons-playground"
    ]
  }

}
