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
2. If they are not a real human or not reasonably trustworthy, close the issue, asking for more information they are a human and not a spam bot. You can explain that by being a member, they can impact repositories immediately.
3. Add the user to the `members` collection in the [`terraform/production/org.tfvars`](https://github.com/django-commons/controls/blob/main/terraform/production/org.tfvars) file.
   ```terraform
     members = [
       # ...
       "new_user"
     ] 
   ```
5. If they requested to be on specific repository team(s), in the [`terraform/production/teams.tfvars`](https://github.com/django-commons/controls/blob/main/terraform/production/teams.tfvars) file, for the repository's key under `teams_repositories`, add them to the `members` collection.
   ```terraform
     teams_repositories = {
       "[REPOSITORY]" = {
         # ...
         members = [
           # ...
           "new_user"
         ]
       }
     }
   ```
6. Create a pull-request to `main` branch, it will trigger terraform to plan the changes in the organization to be
   executed. Review the changes and make sure they align with the request.
7. Merge the pull-request, it will trigger terraform to apply the changes in the organization.

## Team Change Playbook

1. If they are not a real human or not reasonably trustworthy, close the issue, asking for more information they are a human and not a spam bot. You can explain that by being a member, they can impact repositories immediately.
2. For the requested repository's team(s), in the [`terraform/production/teams.tfvars`](https://github.com/django-commons/controls/blob/main/terraform/production/teams.tfvars) file, for the repository's key under `teams_repositories`, add them to the `members` collection.
   ```terraform
     teams_repositories = {
       "[REPOSITORY]" = {
         # ...
         members = [
           # ...
           "new_user"
         ]
       }
     }
   ```
3. Create a pull-request to `main` branch, it will trigger terraform to plan the changes in the organization to be
   executed. Review the changes and make sure they align with the request.
4. Merge the pull-request, it will trigger terraform to apply the changes in the organization.

## New Repository Admin or Committer Playbook

1. Confirm with all existing admins that they are okay with the change
2. If there's disagreement, close the issue and ask for the admins to come to a consensus
3. For the requested repository's team(s), in the [`terraform/production/teams.tfvars`](https://github.com/django-commons/controls/blob/main/terraform/production/teams.tfvars)
   file, for the repository's key under `teams_repositories_privileged`, add them to the `members` collection for the correct team. There will be two privileged teams for each repository, `*-admins` and `*-committers`, the user should be added to the requested team.
   ```terraform
     teams_repositories_privileged = {
       "[REPOSITORY]-[admins | committers]" = {
         # ...
         members = [
           # ...
           "new_user"
         ]
       }
     }
   ```
4. Create a pull-request to `main` branch, it will trigger terraform to plan the changes in the organization to be
   executed. Review the changes and make sure they align with the request.
5. Merge the pull-request, it will trigger terraform to apply the changes in the organization.

## New Project Playbook

1. Check if repository
   meets [inbound requirements](https://github.com/django-commons/membership/blob/main/incoming_repo_requirements.md)
2. Confirm who will be the admins and maintainers for the repository
3. PyPI project owner must add you (Django Commons admin) as owner in PyPI
4. (TODO: Determine how this works with transferring out of an org and into the Django Commons org)
5. [Add repository owner to Django Commons as member](#new-member-playbook) (they'll be added
   to a team later)
6. Share
   link ([https://docs.github.com/en/repositories/creating-and-managing-repositories/transferring-a-repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/transferring-a-repository))
   with repo owner to transfer repo
7. Wait for repository transferred in
8. [Run new team action](https://github.com/django-commons/controls/actions/workflows/new_team.yml)
9. [Make Terraform changes to add new project](#terraform-changes-to-add-a-new-project)
10. [Configure environments](https://docs.github.com/en/actions/administering-github-actions/managing-environments-for-deployment#creating-an-environment) pypi and testpypi in the repository to enable [publishing packages via GitHub Actions](https://packaging.python.org/en/latest/guides/publishing-package-distribution-releases-using-github-actions-ci-cd-workflows/#)
11. For pypi environment, add Deployment protection rule with reviewers as [repo]-admins and enable "Allow
    administrators to bypass configured protection rules"
12. Under Actions > General > "Fork pull request workflows from outside collaborators", set "Require approval for
    first-time contributors"
13. Set a calendar event or reminder for 30 days in the future to remove previous repository owner from team

### Terraform changes to add a new project

Assuming repository name is `repo-name`:

1. In [`terraform/production/respositories.tfvars`](https://github.com/django-commons/controls/blob/main/terraform/production/respositories.tfvars), Add the new repository to the `repositories` section:
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
        has_wiki = false # optional, default is false
        is_template = false # optional, default is false
        push_allowances = []
        required_status_checks_contexts = [] # optional, default is []
        template = "" # optional, default is ""
        topics = []
        visibility  = "public" # optional, default is "public"
      }
   }
   ```
2. In [`terraform/production/teams.tfvars`](https://github.com/django-commons/controls/blob/main/terraform/production/teams.tfvars), add the new team `repo-name` for the repository in the `teams_repositories` section with the
   relevant members:
   ```terraform
   teams_repositories = {
      # ...
      "repo-name" = {
         description = "repo-name team"         
         members = [
           # Put the user from Step 5 here
           "username",
         ]
         permission = "triage"
         repositories = [
           "repo-name",
         ]
     }
   }
   ```
3. Add two new child teams `repo-name-admins` and `repo-name-committers` for the repository in the `teams_repositories_privileged`
   section with the relevant members:
   ```terraform
   teams_repositories_privileged = {
      # ...
      "repo-name-admins" = {
         description = "repo-name admins team"
         parent_team_key = "repo-name"    
         members = [
           # Put the user from Step 5 here
           "username",
         ]
         permission = "admin"
     }
     "repo-name-committers" = {
         description = "repo-name committers team"
         parent_team_key = "repo-name"
         members = [
           # Leave empty unless there are committers ready to be designated
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

1. Remove the repository from the `repositories` section in [`terraform/production/respositories.tfvars`](https://github.com/django-commons/controls/blob/main/terraform/production/respositories.tfvars)
2. Remove the parent team and child teams for the repository from the `teams_repositories` and `teams_repositories_privileged` sections in
   [`terraform/production/teams.tfvars`](https://github.com/django-commons/controls/blob/main/terraform/production/teams.tfvars)
3. Create a pull-request to `main` branch, it will trigger terraform to plan the changes in the organization to be
   executed.
   Review the changes and make sure they align with the request.
4. Merge the pull-request, it will trigger terraform to apply the changes in the organization.
