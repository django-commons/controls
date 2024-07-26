# Organization repositories
repositories = {
  # Keep the following repositories in alphabetical order

  ".github" = {
    description              = "A Special Repository."
    enable_branch_protection = false

    topics = []
    push_allowances = []
    skip_team_creation = true
  }

  "controls" = {
    description              = "The controls for managing Django Commons projects"
    enable_branch_protection = false

    topics = []
    push_allowances = []
    visibility         = "public"
    skip_team_creation = true
  }

  "membership" = {
    description        = "Membership repository for the django-commons organization."
    visibility         = "public"
    topics = []
    push_allowances = []
    skip_team_creation = true
  }

  "django-commons-playground" = {
    description = "A sample project to test things out"
    topics = []
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
}
