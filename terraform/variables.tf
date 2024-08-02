# Input Variables
# https://www.terraform.io/language/values/variables

variable "admins" {
  description = "A set of admins to add to the organization"
  type = set(string)
}

variable "github_token" {
  description = "The GitHub token used for managing the organization"
  type        = string
  sensitive   = true
}

variable "members" {
  description = "A set of members to add to the organization"
  type = set(string)
  default = []
}

variable "repositories" {
  description = "Map of repositories to create"
  type = map(object({
    description = string
    allow_auto_merge = optional(bool, false)
    allow_merge_commit = optional(bool, false)
    allow_rebase_merge = optional(bool, false)
    allow_squash_merge = optional(bool, true)
    allow_update_branch = optional(bool, true)
    enable_branch_protection = optional(bool, true)
    has_discussions = optional(bool, true)
    has_downloads = optional(bool, true)
    has_wiki = optional(bool, false)
    is_template = optional(bool, false)
    push_allowances = optional(list(string), [])
    required_status_checks_contexts = optional(list(string), [])
    template = optional(string)
    topics = optional(list(string))
    visibility = optional(string, "public")
    skip_team_creation = optional(bool, false) # Do not create teams for repository
    admins = optional(set(string), []) # Members of the repository's admin and repository teams. Have admin permissions
    committers = optional(set(string), [])
    # Members of the repository's committers and repository teams. Have write permissions
    members = optional(set(string), []) # Members of the repository team. Have triage permissions
  }))
}

variable "organization_teams" {
  description = "Map of Django Commons organization teams to manage"
  type = map(object({
    description = string
    maintainers = optional(set(string), [])
    members = optional(set(string), [])
    permission = optional(string, null)
    privacy = optional(string, "closed")
    repositories = optional(set(string), [])
    review_request_delegation = optional(bool, false)
  }))
}

variable "organization_secrets" {
  description = "Map of secrets to add to the organization"
  type = map(object({
    description = string
    visibility  = string
  }))
}
