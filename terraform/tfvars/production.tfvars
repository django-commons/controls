admins = [
  "tim-schilling",
  "williln",
  "ryancheley",
  "Stormheg",
  "cunla",
]
members = [
  "gav-fyi",
  "jcjudkins",
  "joshuadavidthomas",
  "matthiask",
  "nanorepublica",
  "Natim",
  "pfouque",
  "priyapahwa",
  "testSchilling",
]

organization_secrets = {
  #   "GPG_PASSPHRASE" = {
  #     description = "GPG Passphrase used to encrypt plan.out files"
  #     visibility  = "all"
  #   }
}

repositories = {
  # Keep the following repositories in alphabetical order

  ".github" = {
    description              = "A Special Repository."
    enable_branch_protection = false

    topics = []

    push_allowances = []
  }

  "controls" = {
    description              = "The controls for managing Django Commons projects"
    enable_branch_protection = false

    topics = []

    push_allowances = []

    visibility = "public"
  }

  "membership" = {
    description = "Membership repository for the django-commons organization."
    visibility  = "public"

    topics = []

    push_allowances = [
    ]
  }

  "django-commons-playground" = {
    description = "A sample project to test things out"

    topics = []
  }

}

team_children = {
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
      "django-commons-playground"
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

team_parents = {
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

  "security-team" = {
    description = "django-commons security team"
    maintainers = [
      "tim-schilling",
    ]
    members = []
    permission = "push"

    repositories = [

    ]

  }
}
