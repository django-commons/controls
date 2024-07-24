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
    allow_squash_merge = optional(bool, false)
    allow_update_branch = optional(bool, false)
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

variable "teams_repositories" {
  description = "Map of repository teams to manage"
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

variable "teams_repositories_privileged" {
  description = "Map of repository teams with elevated permissions to manage"
  type = map(object({
    description     = string
    maintainers = optional(set(string), [])
    members = optional(set(string), [])
    permission = optional(string, null)
    parent_team_key = string
    repositories = optional(set(string), [])
  }))
}

variable "organization_secrets" {
  description = "Map of secrets to add to the organization"
  type = map(object({
    description = string
    visibility  = string
  }))
}
