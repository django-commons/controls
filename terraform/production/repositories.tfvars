# Organization repositories
repositories = {
  # Keep the following repositories in alphabetical order

  ".github" = {
    description              = "A Special Repository."
    enable_branch_protection = false

    topics             = []
    push_allowances    = []
    skip_team_creation = true
  }

  "controls" = {
    description              = "The controls for managing Django Commons projects"
    enable_branch_protection = false
    allow_merge_commit       = true
    allow_rebase_merge       = true
    allow_squash_merge       = true
    topics                   = []
    push_allowances          = []
    skip_team_creation       = true
  }

  "membership" = {
    description        = "Membership repository for the django-commons organization."
    visibility         = "public"
    allow_merge_commit = true
    allow_rebase_merge = true
    allow_squash_merge = true
    topics             = []
    push_allowances    = []
    skip_team_creation = true
  }

  "django-commons-playground" = {
    description = "A sample project to test things out"
    topics      = []
    # People with GitHub admin repo permissions
    admins = [
      "tim-schilling",
      "williln",
      "ryancheley",
      "Stormheg",
      "cunla",
    ]
    # People with GitHub maintain repo permissions
    committers = [
      "priyapahwa",
    ]
    # People with GitHub triage repo permissions
    members = [
    ]
  }

  "django-tasks-scheduler" = {
    description  = "Schedule async tasks using redis pub/sub."
    homepage_url = "https://django-tasks-scheduler.readthedocs.io/"

    admins = [
      "cunla",
    ]
    committers = []
    members    = []
  }
}
