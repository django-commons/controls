GitHub Organization as Terraform
================================

Structure

- `variables.tf` - define variable types (classes?), notice there is `variable "repositories" {...` there which has a
  few variables marked as optional with default values. Why I chose to have `has_discussions` as a repo variable
  while `has_issues` as a constant - I am embarrassed to say I don't have a better answer than laziness :smile: - I just
  figured if this is the path we want to take, we can continue adding to it.
- `production.tfvars` - instances, should strictly follow the types in `variables.tf`.
- `main.tf` - build configuration based on instances values from `production.tfvars` (or, if not defined explicitly,
  then default value from `variables.tf`)
- `tfstate.json` - Current state file, pulled using `terraform import ..`

# Why Terraform?

We can define our "desired/default" repository configuration, and within this configuration:

- What is enforced from day one (i.e., constant in `resource "github_repository" "this"`)
- What is recommended but can be changed by users (i.e., variable with a default value in `variables.tf` that can be
  updated in `production.tfvars`) => Note this can also help us review outliers, you can see all repos which have
  non-default values in the `production.tfvars` file.
- What is determined by users (i.e., variables without default value, like `description`)
- What is not configured in the infra-as-code (currently, for example, repo-labels).

# How to use?

1. Clone the repository.
2. From the `terraform/` directory, run `terraform init`.
3. Create a github-token with the necessary permissions on the organization.
4. Make changes to `production.tfvars` to reflect the desired state (add/update users, repositories, teams, etc.)
5. To see what changes between the current state of the GitHub organization and the plan
   run:  `terraform plan -var-file=tfvars/production.tfvars -var github_token=...`
6. To apply the changes, run: `terraform apply -var-file=tfvars/production.tfvars -var github_token=...`

# What changes can be made

All changes should be made in `production.tfvars`:

- Add/Remove organization admins by editing the `admins` list.
- Add/Remove organization members by editing the `members` list.
- Add/Remove/Update repositories by editing the `repositories`. A repository can have the following variables:
    ```terraform
    repositories = {
      "repo-name" = {
        description = "repo description"
        allow_auto_merge = false # optional, default is false
        allow_merge_commit = false # optional, default is false
        allow_rebase_merge = false # optional, default is false
        allow_squash_merge = false # optional, default is false
        allow_update_branch = false # optional, default is false
        enable_branch_protection = true # optional, default is true
        has_discussions = true # optional, default is true
        has_downloads = true # optional, default is true
        is_template = false # optional, default is false
        push_allowances = []
        required_status_checks_contexts = [] # optional, default is []
        template = "" # optional, default is ""
        topics = []
        visibility  = "public" # optional, default is "public"
      }
     # ...
    }
    ``` 
- Add/Remove/Update teams by editing the `team_parents`. A team can have the following variables:
    ```terraform
    team_parents = {
      "Admins" = {
        description = "django-commons administrators"
        maintainers = ["tim-schilling",]
        members = ["cunla",]
        permission = "admin" # optional, default is null
        privacy = "closed" # optional, default is "closed"
        repositories = [ # optional, default is []
          "django-commons/controls",
          "django-commons/membership",
          "django-commons/terraform",
        ]
        review_request_delegation = false # optional, default is false
      }
      # ...
    }
    ```
- Add/Remove/Update child-teams by editing the `team_children`. A child-team can have the following variables:
    ```terraform
    team_children = {
      "New-Admins" = {
        description = "django-commons administrators"
        parent_team_key = "Admins"
        maintainers = ["tim-schilling",]
        members = ["cunla",]
        permission = "admin" # optional, default is null
        privacy = "closed" # optional, default is "closed"
        repositories = [ # optional, default is []
          "django-commons/controls",
          "django-commons/membership",
          "django-commons/terraform",
        ]
        review_request_delegation = false # optional, default is false
      }
      # ...
    }
    ```