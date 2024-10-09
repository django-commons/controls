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
2. If they are not a real human or not reasonably trustworthy, close the issue, asking for more information they are a
   human and not a spambot. You can explain that by being a member, they can impact repositories immediately.
3. Add the user's GitHub username to the `members` collection in
   the [`terraform/production/org.tfvars`][1]
   file. Please keep the list sorted alphabetically.
   ```terraform
     members = [
       # ...
       "new_user"
     ] 
   ```
4. If they requested to be on specific repository team(s), in
   the [`terraform/production/repositories.tfvars`][2]
   file, add them to the `members` collection. Please keep the list sorted alphabetically.
   ```terraform 
     repositories = {
       "[REPOSITORY]" = {
         # ...
         members = [
           # ...
           "new_user"
         ]
       }
     }
   ```
5. Create a pull-request to `main` branch. This will trigger terraform to plan the changes in the organization to be
   executed. Review the changes and make sure they align with the request.
6. Merge the pull request. This will trigger terraform to apply the changes in the organization.
7. Comment on the issue, thanking the person for joining and reminding them that it helps the
   organization's reach if they set their membership visibility as public.

   > Thank you <NAME> for joining! You'll get an invite email from GitHub. You'll have one
   > week to accept that. If you don't mind, after accepting, can you set your
   > [organization membership as public](https://github.com/orgs/django-commons/people)?
   > This helps Django Commons grow.

## Repository Team Change Playbook

1. If they are not a real human or not reasonably trustworthy, close the issue, asking for more information if they are
   a human and not a spambot. You can explain that by being a member, they can impact repositories immediately.
2. For the requested repository's team(s), in
   the [`terraform/production/repositories.tfvars`][2]
   file, add them to the `members` collection. Please keep the list sorted alphabetically.
   ```terraform
     repositories = {
       "[REPOSITORY]" = {
         # ...
         members = [
           # ...
           "new_user"
         ]
       }
     }
   ```
3. Create a pull-request to `main` branch. This will trigger terraform to plan the changes in the organization to be
   executed. Review the changes and make sure they align with the request.
4. Merge the pull request. This will trigger terraform to apply the changes in the organization.

## New Repository Admin or Committer Playbook

1. Confirm with all existing admins that they approve changes to the repository admins or committers.
2. If there's disagreement, close the issue and ask for the admins to come to a consensus
3. For the requested repository's team(s), in
   the [`terraform/production/repositories.tfvars`][2]
   file, for the repository's key under `repositories`, add them to the `admins` collection for the
   correct team. There will be two privileged teams for each repository, `*-admins` and `*-committers`, the user should
   be added to the requested team. Please keep the list sorted alphabetically.
   ```terraform
     repositories = {
       "[REPOSITORY]" = {
         # ...
         admins = [
           # ...
           "new_user"
         ]
       }
     }
   ```
4. Create a pull-request to `main` branch. This will trigger terraform to plan the changes in the organization to be
   executed. Review the changes and make sure they align with the request.
5. Merge the pull request. This will trigger terraform to apply the changes in the organization.

## New Project Playbook

Assuming the repository name is `repo-name`:

### Pre Transfer Steps

- [ ] Check if the repository meets [inbound requirements][3].
- [ ] Confirm who will be the admins and maintainers for the repository
- [ ] Make sure the there are no teams `{repo-name}`, `{repo-name}-admins` and `{repo-name}-committers` in the Django
  Commons organization. Teams can be viewed [here][teams]. The teams will be created by the terraform apply process.
- [ ] (project owner) PyPI project owner must add the Django Commons pypi's team members as owners in [PyPI][pypi],
  and [test-pypi][test-pypi]
  (TODO: Determine how this works with transferring out of an org and into the Django Commons org)
- [ ] [Add repository owner to Django Commons as member](#new-member-playbook) (they'll be added to a team later)
- [ ] (project owner) Transfer the existing repository to the Django Commons organization using the GitHub UI, so old
  information is preserved. See [GitHub docs][gh-docs-transfer-repo].

### Post Transfer Steps

- [ ] Terraform changes to add project to organization
    - [ ] In [`terraform/production/respositories.tfvars`][2], add the new repository to the `repositories` section:

       ```terraform
       repositories = {
         # ...
         "repo-name" = {
           description = "repo description"
           homepage_url = "" # optional, default is ""
           allow_auto_merge = false # optional, default is false
           allow_merge_commit = false # optional, default is false
           allow_rebase_merge = false # optional, default is false
           allow_squash_merge = true # optional, default is true
           allow_update_branch = true # optional, default is true
           delete_branch_on_merge = true # optional, default is true
           has_discussions = true # optional, default is true
           has_downloads = true # optional, default is true
           has_wiki = false # optional, default is false
           is_template = false # optional, default is false
           push_allowances = []
           template = "" # optional, default is ""
           topics = []
           visibility = "public" # optional, default is "public"
           is_django_commons_repo = optional(bool, false) # Do not create teams for repository
           enable_branch_protection = true # optional, default is true
           required_status_checks_contexts = [] # optional, default is []
           admins = [] # Members of the repository's admin and repository teams. Have admin permissions
           committers = [] # Members of the repository's committers and repository teams. Have write permissions
           members = [] # Members of the repository team. Have triage permissions
         }
       }
       ```

    - [ ] Create a pull-request to `main` branch. This will trigger terraform to plan the changes in the organization to
      be executed.
      Review the changes and make sure they align with the request.
    - [ ] Merge the pull request. This will trigger terraform to apply the changes in the organization.
    - The expected changes:
        - [ ] New teams `repo-name`, `repo-name-admins`, `repo-name-committers` with the relevant members based on the
          repository's description.
        - [ ] The repository changes are accepted by the project maintainers.
        - [ ] Repository has two environments: `pypi` and `testpypi`, see example [here][playground-environments]

- [ ] Repo changes:
    - [ ] (project owner) Create/Update the release GitHub workflow in the repository, example can be
      found [here][release-gh-workflow]
    - [ ] Under Actions > General > "Fork pull request workflows from outside collaborators", set "Require approval for
      first-time contributors"

- [ ] pypi and test-pypi changes:
    - [ ] Add the release workflow to pypi.org's package publishing (and test.pypi.org's package publishing).
      Example can be found [here][pypi-publishing]

- [ ] Have the maintainer push a new tag and walk them through the release process
- [ ] Set a calendar event or reminder for 30 days in the future to remove the previous repository owner from PyPI
  project (if applicable)

## Remove Project Playbook

1. Confirm there's agreement amongst current project maintainers to move project out of Django Commons
2. Add new Owner(s) to project in PyPI
3. [Transfer GitHub repo to new owner or Org][people]
4. Wait for repository to be transferred out.
5. Remove all Django Commons members from PyPI project (except any that are staying on from step 2)
6. (TODO: Determine how to handle transferring a PyPI project out of an organization)

### Terraform changes to remove a project

1. Remove the repository from the `repositories` section
   in [`terraform/production/respositories.tfvars`][2]
2. Create a pull-request to `main` branch. This will trigger terraform to plan the changes in the organization to be
   executed.
   Review the changes and make sure they align with the request.
3. Merge the pull request. This will trigger terraform to apply the changes in the organization.

The expected changes:

- The repository will be removed from the organization.
- The repository's teams will be removed from the organization.

[1]: https://github.com/django-commons/membership/blob/main/terraform/production/org.tfvars

[2]: https://github.com/django-commons/membership/blob/main/terraform/production/repositories.tfvars

[3]: https://github.com/django-commons/membership/blob/main/incoming_repo_requirements.md

[people]: https://github.com/orgs/django-commons/people

[teams]: https://github.com/orgs/django-commons/teams

[test-pypi]: https://test.pypi.org/manage/project/django-commons/

[pypi]: https://pypi.org/

[gh-docs-transfer-repo]: https://docs.github.com/en/repositories/creating-and-managing-repositories/transferring-a-repository

[release-gh-workflow]: https://github.com/django-commons/django-commons-playground/blob/main/.github/workflows/release.yml

[pypi-publishing]: https://test.pypi.org/manage/project/django-tasks-scheduler/settings/publishing/

[playground-enviroments]: https://github.com/django-commons/django-commons-playground/settings/environments