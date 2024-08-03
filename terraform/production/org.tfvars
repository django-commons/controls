# Organization admins
admins = [
  "tim-schilling",
  "williln",
  "ryancheley",
  "Stormheg",
  "cunla",
]
# Organization members
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
  "maerteijn",
  "g-nie",
]

organization_teams = {
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
  }
}

################ GitHub Organization Secrets, not used at the moment #############

organization_secrets = {
  #     "GPG_PASSPHRASE" = {
  #       description = "GPG Passphrase used to encrypt plan.out files"
  #       visibility  = "all"
  #     }
}
