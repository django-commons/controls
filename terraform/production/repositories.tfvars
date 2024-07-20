# Organization repositories
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
    push_allowances = []
  }

  "django-commons-playground" = {
    description = "A sample project to test things out"
    topics = []
  }
}
