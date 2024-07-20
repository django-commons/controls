# Django Commons Controls

This repository contains all the information for administrators to manage
Django Commons packages.

- [New member](#new-member-playbook)
- [Team change](#team-change-playbook)
- [New repository admin](#new-repository-admin-playbook)
- [New project](#new-project-playbook)
- [Remove project](#remove-project-playbook)

## New Member Playbook

1. Review new issues/application at https://github.com/django-commons/membership/issues/
2. If they are a real human and are reasonably trustworthy, comment "Approved" and nothing else
    - If they aren't a real human or reasonably trustworthy, close the issue.
    - Apply the needed terraform changes to add the member to the organization.

### Terraform changes to add member to the organization

- Change `production.tfvars`: add the username under `members`, like this:
  ```terraform
     members = [
       # ...
       "new_user"
     ] 
  ```
- Create a pull-request to `main` branch, it will trigger terraform to plan the changes in the organization to be
  executed. Review the changes and make sure they align with the request.
- Merge the pull-request, it will trigger terraform to apply the changes in the organization.

## Team Change Playbook

1. If they are a real human and are reasonably trustworthy, comment "Approved" and close the issue manually
2. Add the member to requested team(s)

### Terraform changes to add member to the team

- Change `production.tfvars`: find the relevant team under `team_parents` or `team_children`, and edit its members:
  ```terraform
  team_children = {
     # ...
     "django-community-playground-admins" = {
       description     = "django-community-playground administrators"
       parent_team_key = "django-community-playground"
       permission      = "admin"           
       members = [
            # ...
            "new_user"
       ]
  
       repositories = [
         "django-commons-playground",
       ]
     }
  }         
  ```
- Create a pull-request to `main` branch, it will trigger terraform to plan the changes in the organization to be
  executed. Review the changes and make sure they align with the request.
- Merge the pull-request, it will trigger terraform to apply the changes in the organization.

## New Repository Admin Playbook

1. Confirm with all existing admins that they are okay with the prospective admin
2. If there's disagreement, close the issue and ask for the admins to come to a consensus
3. If there's agreement, add the prospective admin to the [repo]-admins team

### Changes in terraform to add a new repository admin

Change `production.tfvars`:

- Find the relevant team under `team_children` and edit its members:
  ```terraform
  team_children = {
     # ...
     "django-community-playground-admins" = {
       description     = "django-community-playground administrators"
       parent_team_key = "django-community-playground"
       permission      = "admin"           
       members = [
            # ...
            "new_user"
       ]
  
       repositories = [
         "django-commons-playground",
       ]
     }
  }         
  ```
- Create a pull-request to `main` branch, it will trigger terraform to plan the changes in the organization to be
  executed. Review the changes and make sure they align with the request.
- Merge the pull-request, it will trigger terraform to apply the changes in the organization.

## New Project Playbook

1. Check if repository
   meets [inbound requirements](https://github.com/django-commons/membership/blob/main/incoming_repo_requirements.md)
2. Confirm who will be the admins and maintainers for the repository
3. PyPI project owner must add you (Django Commons admin) as owner in PyPI
4. (TODO: Determine how this works with transfering out of an org and into the Django Commons org)
5. [Add repository owner to Django Commons as member](https://github.com/orgs/django-commons/people) (they'll be added
   to a team later)
6. Share
   link ([https://docs.github.com/en/repositories/creating-and-managing-repositories/transferring-a-repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/transferring-a-repository))
   with repo owner to transfer repo
7. Wait for repository transferred in
8. [Run new team action](https://github.com/django-commons/controls/actions/workflows/new_team.yml)
9. Invite repository admins to [repo]-admins team, repository maintainers to [repo]-committers team
10. Configure environments pypi and testpypi
11. For pypi environment, add Deployment protection rule with reviewers as [repo]-admins and enable "Allow
    administrators to bypass configured protection rules"
12. Under Actions > General > "Fork pull request workflows from outside collaborators", set "Require approval for
    first-time contributors"
13. Add previous repository owner to [repo]-admins team
14. Set a calender event or reminder for 30 days in the future to remove previous repository owner from team

### Terraform changes to add a new project

Changes in `production.tfvars` (Assuming repository name is `repo-name`):

1. Add the new repository to the `repositories` section:
   ```terraform
   repositories = {
      # ...
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
   }
   ```
2. Add the new parent team `repo-name` for the repository in the `team_parents` section with the relevant members:
   ```terraform
   team_parents = {
      # ...
      "repo-name" = {
         description = "django-community-playground team"         
         members = [
           "tim-schilling",
           "williln",
         ]
         permission = "triage"
  
         repositories = [
               "repo-name",
         ]
         review_request_delegation = true
     }
   }
   ```
3. Add two new child teams `repo-name-admin` and `repo-name-committers` for the repository in the `team_children`
   section
   with the relevant members:
   ```terraform
   team_children = {
      # ...
      "repo-name-admin" = {
         description = "django-community-playground team"
         parent_team_key = "repo-name"
         members = [
           "tim-schilling",
           "williln",
           "ryancheley",
           "Stormheg",
           "cunla",
         ]
         permission = "admin"
     }
     "repo-name-committers" = {
         description = "django-community-playground team"
         parent_team_key = "repo-name"
         members = [
           "tim-schilling",
           "williln",
           "ryancheley",
           "Stormheg",
           "cunla",
         ]
         permission = "push"
     }
   }
   ```
4. Create a pull-request to `main` branch, it will trigger terraform to plan the changes in the organization to be
   executed. Review the changes and make sure they align with the request.
5. Merge the pull-request, it will trigger terraform to apply the changes in the organization.

## Remove Project Playbook

1. Confirm there's agreement amongst current project maintainers to move project out of Django Commons
2. Add new Owner(s) to project in PyPI
3. [Transfer GitHub repo to new owner or Org](https://github.com/orgs/django-commons/people)
4. Wait for repository to be transferred out.
5. Remove all Django Commons members from PyPI project (except any that are staying on from step 2)
6. (TODO: Determine how to handle transferring a PyPI project out of an organization)

### Terraform changes to remove a project
1. Remove the repository from the `repositories` section in `production.tfvars`
2. Remove the parent team and child teams for the repository from the `team_parents` and `team_children` sections in
   `production.tfvars`
3. Create a pull-request to `main` branch, it will trigger terraform to plan the changes in the organization to be
   executed.
   Review the changes and make sure they align with the request.
4. Merge the pull-request, it will trigger terraform to apply the changes in the organization.
