GitHub Organization as Terraform
================================

# Structure

- `variables.tf` - define variable types (classes?), notice there is `variable "repositories" {...` there which has a
  few variables marked as optional with default values. Why I chose to have `has_discussions` as a repo variable
  while `has_issues` as a constant - I am embarrassed to say I don't have a better answer than laziness :smile: - I just
  figured if this is the path we want to take, we can continue adding to it.
- `production/*.tfvars` - instances, should strictly follow the types in `variables.tf`.
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

# What changes can be made

All changes should be made in `production/*.tfvars`:

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
        has_wiki = false # optional, default is false
        is_template = false # optional, default is false
        push_allowances = []
        required_status_checks_contexts = [] # optional, default is []
        template = "" # optional, default is ""
        topics = []
        visibility  = "public" # optional, default is "public"
        skip_team_creation = optional(bool, false) # Do not create teams for repository
        admins = optional(set(string), []) # Members of the repository admin team
        committers = optional(set(string), []) # Members of the repository committers team
      }
     # ...
    }
    ```

# How to use locally

You might want to try new settings locally before applying them to the repository automation.
To do so, you can use the following steps:

1. Clone the repository.
2. From the `terraform/` directory, run `terraform init`.
3. Create a github-token with the necessary permissions on the organization (see [permissions documentation][1]).
    - The `repo` permisison for full control of private repositories.
    - The `admin:org` permission for full control of orgs and teams, read and write org projects
    - The `delete_repo` permission to delete repositories

4. Make changes to `production/*.tfvars` to reflect the desired state (add/update users, repositories, teams, etc.)
5. To see what changes between the current state of the GitHub organization and the plan
   run:  `terraform plan -var-file=production/org.tfvars -var-file=production/repositories.tfvars -var github_token=...`
6. To apply the changes, run: `terraform apply -var-file=production/org.tfvars -var-file=production/repositories.tfvars -var github_token=...`

[1]: https://developer.hashicorp.com/terraform/tutorials/it-saas/github-user-teams#configure-your-credentials