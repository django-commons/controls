# Django Commons Controls

This repository contains all the information for administrators to manage Django Commons packages.

- [New member](#new-member-playbook)
- [Repository Team change](#repository-team-change-playbook)
- [New Repository Admin or Committer](#new-repository-admin-or-committer-playbook)
- [New project](#new-project-playbook)
- [Remove project](#remove-project-playbook)
- [Project checkin](#project-checkin-playbook)
- [Project status change](#project-status-change-playbook)
- [Update admin team](#update-admin-team)

## New Member Playbook

1. Review new issues/application at https://github.com/django-commons/membership/issues/
2. If they are not a real human or not reasonably trustworthy
   ([new member requirements](https://github.com/django-commons/membership/blob/main/member_requirements.md)), close the
   issue, asking for more information they are a human and not a spambot. You can explain that by being a member, they
   can impact repositories immediately.
3. Add the user's GitHub username to the `members` collection in the [`terraform/org.tfvars`][1]
   file. Please keep the list sorted alphabetically.
   ```terraform
     members = [
       # ...
       "new_user"
     ] 
   ```
4. Review the [failing invitations][failed-invitations], remove members that are in the failing invitations list from
   the [`terraform/org.tfvars`][1].
5. If they requested to be on specific repository team (s), in the [`terraform/repositories.tfvars`][2]
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
   If there are extra users added in the PR when there shouldn't be, it's possible a user deleted their GitHub account.
   Check to see if that new user has a GitHub account and confirm they had issued a previous request to join Django
   Commons. Users who haven't accepted the Code of Conduct should not be invited.
6. Create a pull-request to `main` branch. This will trigger terraform to plan the changes in the organization to be
   executed. Review the changes and make sure they align with the request.
7. Merge the pull request. This will trigger terraform to apply the changes in the organization.
8. Comment on the issue, thanking the person for joining and reminding them that it helps the organization's reach if
   they set their membership visibility as public.

   > Thank you <NAME> for joining! You'll get an invite email from GitHub. You'll have one
   > week to accept that. If you don't mind, after accepting, can you set your
   > [organization membership as public](https://github.com/orgs/django-commons/people)?
   > This helps Django Commons grow.

## Repository Team Change Playbook

1. If they are not a real human or not reasonably trustworthy, close the issue, asking for more information if they are
   a human and not a spambot. You can explain that by being a member, they can impact repositories immediately.
2. For the requested repository's team (s), in the [`terraform/repositories.tfvars`][2]
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
3. For the requested repository's team (s), in the [`terraform/repositories.tfvars`][2]
   file, for the repository's key under `repositories`, add them to the `admins` collection for the correct team. There
   will be two privileged teams for each repository, `*-admins` and `*-committers`, the user should be added to the
   requested team. Please keep the list sorted alphabetically.
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
6. Add the new admin's email [projects' spreadsheet][project-checkins-doc] under the relevant project
7. Add the new admin to the relevant [Open Collective project][open-collective] as admin

## New Project Playbook

Goal: Publish a new release of the project from django-commons repo to PyPI and Test PyPI, using the release workflow.

Assuming the repository name is `repo-name`:

```terraform
"your-repo-here" = {
  description = "Your project's description here"
  allow_merge_commit = true # Allow merge commits on pull requests
  allow_rebase_merge = true # Allow rebase and merge commits on pull requests
  allow_squash_merge = true # Allow squash and merge commits on pull requests - Recommended
  allow_update_branch = true # Allow updating source branch on pull requests
  has_discussions = false # Enable discussions in project's repository
  has_wiki = false # Enable wiki in project's repository
  admins = [
    # Include people who can release new versions
    "your-username-here",
  ]
  committers = [
    # Include people who can commit to main / merge changes
  ]
  members = [
    # Include people who can assign/triage tickets
  ]
}
```

### Pre Transfer Steps

- [ ] Check if the repository meets [inbound requirements][incoming-requirements].
- [ ] A PR to add the [release workflow][release-gh-workflow] will be necessary. This can be done either by the repo
  owner OR the Django commons org admins, but should be done prior to the video call. The decision is up to the repo
  owner. **The PR should NOT be merged before the video call.**
    - [ ] (if applicable) If the package has a JavaScript component published to npm, the workflow will need to be
      modified to include publishing to npm
      using [trusted publishing](https://docs.npmjs.com/trusted-publishers#github-actions-configuration)
- [ ] Confirm who will be the admins and maintainers for the repository
- [ ] Make sure the there are no teams `{repo-name}`, `{repo-name}-admins` and `{repo-name}-committers` in the Django
  Commons organization. Teams can be viewed [here][teams]. The teams will be created by the terraform apply process.
- [ ] Review with project-owner the newly created teams roles, as documented in [the membership repository][team-roles].
- [ ] [Add repository owner to Django Commons as member](#new-member-playbook) (they'll be added to a team later)

### Transfer ownership in GitHub, test PyPI and PyPI.

These should be done by the project owner.

- [ ] Invite djangocommons@gmail.com to the [readthedocs project][readthedocs] as a maintainer, so the Django Commons
  admins can manage the readthedocs project.
- [ ] Transfer the existing repository to the Django Commons organization using the GitHub UI, so old information is
  preserved. See [GitHub docs][gh-docs-transfer-repo].
    - It takes GitHub a couple minutes to process the move, therefore it is highly recommended to do this step first.
      This will ensure enough time can pass before moving to the 'import into terraform' step.
- [ ] (project owner) PyPI project owner must add one of the Django Commons Admins as owners in [PyPI][pypi],
  and [test-pypi][test-pypi]
    - [ ] Once the project is owned by a member of the Django Commons PyPI organization, the project can be transferred
      to the Django Commons PyPI organization from the org page [here][pypi-org].
- [ ] Review with the project owner the PyPI and Test PyPI project maintainers - consider removing any inactive
  maintainers from the project.

## NPM (if applicable)

These steps apply if the package has a JavaScript component published to npm. Otherwise, skip this section.

- [ ] (project owner) current NPM project owner must add one of the Django Commons Admins as maintainer to the NPM
  package
    - [ ] Once the project is owned by a member of the Django Commons NPM organization, a new team named after the
      project should be created in the django-commons NPM organization with and the new maintainers invited as members
      of that team.
    - [ ] Through the NPM interface, use the 'add existing package' option to transfer the package by clicking the
      'packages' button next to the team in the list of teams in the organization.
    - [ ] Review with the project owner the NPM package maintainers - consider removing any inactive maintainers from
      the project.

### Make GitHub repository managed by terraform

- [ ] Terraform changes to add project to organization, should be included in the issue opened to transfer the project.
    - [ ] In [`terraform/respositories.tfvars`][2], add the new repository to the `repositories` section:

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
           required_status_checks_contexts = [] # optional, default is []
           admins = [] # Members of the repository's admin and repository teams. Have admin permissions
           committers = [] # Members of the repository's committers and repository teams. Have write permissions
           members = [] # Members of the repository team. Have triage permissions
         }
       }
       ```
    - [ ] Create a pull-request to `main` branch. This will trigger terraform to plan the changes in the organization to
      be executed. Review the changes and make sure they align with the project maintainer expectations.
    - [ ] Merge the pull request. This will trigger terraform to apply the changes in the organization.
    - The expected changes:
        - [ ] New teams `repo-name`, `repo-name-admins`, `repo-name-committers` with the relevant members based on the
          repository's description.
        - [ ] The repository changes are accepted by the project maintainers.
        - [ ] Repository has two environments: `pypi` and `testpypi`, see example [here][best-practice-environments]

### Create new release workflow

- [ ] Repo changes:
    - [ ] (project owner) Merge pull-request implementing the release workflow (created in the pre-transfer steps).
    - [ ] Under Actions > General > "Fork pull request workflows from outside collaborators", set "Require approval for
      first-time contributors"

- [ ] PyPI and Test PyPI changes:
    - [ ] Add the release workflow to pypi.org's package publishing (and test.pypi.org's package publishing). Example
      can be found [here][pypi-publishing]
- [ ] NPM changes (if applicable):
    - [ ] Add a trusted publisher in the NPM package settings for the GitHub Actions workflow to be able to publish to
      NPM using trusted publishing.
      See [trusted publishing docs](https://docs.npmjs.com/trusted-publishers#github-actions-configuration).

### Release a new version

- [ ] Have the maintainer push a new tag and walk them through the release process
    - Find the publishing workflow in the Actions tab (Usually  `Publish Python 🐍 distribution 📦 to PyPI`/`release.yml`)
    - The publishing to pypi job should wait for an approval by a repository admin.
- [ ] (If applicable) confirm the NPM package can also be published using the Trusted Publisher
    - [ ] When successful, consider disallowing NPM access tokens be used to control the package,
      see [docs.npmjs.org | How to configure maximum security](https://docs.npmjs.com/trusted-publishers#how-to-configure-maximum-security)

### Follow up

- [ ] Add the project and the admins' emails to the [Django Commons Project Checkins doc][project-checkins-doc]
- [ ] Set a calendar event or reminder for 30 days in the future to check in with the project maintainers to see if they
  need any help or have any questions.
- [ ] Create a project in the [Open Collective dashboard][open-collective] for the repo, and invite the admins to it.

## Remove Project Playbook

1. Confirm there's agreement amongst current project maintainers to move project out of Django Commons
2. Add new Owner (s) to project in PyPI
3. [Transfer GitHub repo to new owner or Org][people]
4. Wait for repository to be transferred out.
5. Remove the [django-commons PyPI organization](https://pypi.org/org/django-commons/) from the PyPI project.
6. (If applicable) Transfer the npm package out of the
   [django-commons npm organization](https://www.npmjs.com/org/django-commons)
7. (If applicable) django-commons is removed as maintainer from the ReadTheDocs project

### Terraform changes to remove a project

1. Remove the repository from the `repositories` section in [`terraform/respositories.tfvars`][2]
2. Create a pull-request to `main` branch. This will trigger terraform to plan the changes in the organization to be
   executed. Review the changes and make sure they align with the request.
3. Merge the pull request. This will trigger terraform to apply the changes in the organization.

The expected changes:

- The repository will be removed from the organization.
- The repository's teams will be removed from the organization.

## Project Checkin Playbook

1. Review [Django Commons Project Checkins doc][project-checkins-doc]
2. Look for the project's [GitHub discussion for checkins][project-checkins-discussions], if it doesn't exist create one
3. Review any prior discussion, complete previous action items and prepare next discussion comment
4. Create a new message, tagging the repository's team that is similar to:
   ```
   Hi @REPOSITORY_TEAM! I wanted to take a moment and check in with you about how the transition to Django Commons has been.

   - Have you run into any friction having your project in Django Commons, if so, can you describe them?
   - Is there anything we can do to help your team or repo out?
   - Do you have any questions or concerns for us?

   If you'd like to chat with us privately, our email is django-commons-admin@googlegroups.com. Thanks!
   ```
5. Update the [Django Commons Project Checkins doc][project-checkins-doc]
6. Follow-up on any responses from the discussion.

## Project Status Change Playbook

Goal: Make sure downstream users know when a project's maintenance status changes,
per the states defined in [Project Maintenance Governance][project-maintenance-governance].

This applies any time a project moves between Healthy, Dormant, Commons Stewardship,
or Archived — in either direction (e.g. a Dormant project regaining an active maintainer
counts as a status change too).

1. Confirm the new status with the admin team before communicating anything publicly.
2. Notify the current project maintainer(s) directly, with advance notice, before making
any of the changes below. This is a heads-up, not a request for permission, but it gives
the maintainer a chance to raise concerns, ask questions, or flag if the timing is off.
For example:

   > Hi `@project-maintainer`, the Django Commons Admins team determined that this project has
   > become dormant because of [reason(s) — e.g. lack of recent commits/releases, an
   > unaddressed security report, etc.] as per our [Project Maintenance doc][project-maintenance-governance]. On [date], we will be making the following
   > changes so the project reflects this status. If you feel like we should hold off
   > or have questions, please let us know!

   Give a reasonable window between this notice and the date changes actually go in.
3. Add or update a status badge in the project's `README.md` reflecting the new state,
placed alongside the project's other badges (build status, PyPI version, etc.), using
[shields.io](https://shields.io) static badges:
   - [ ] Healthy: no badge needed (default state)
   - [ ] Dormant: [![Maintenance Status: Seeking Maintainer](https://img.shields.io/badge/maintenance-seeking%20maintainer-yellow)][project-maintenance-governance]
   - [ ] Commons Stewardship: [![Maintenance Status: Commons Stewardship](https://img.shields.io/badge/maintenance-commons%20stewardship-orange)][project-maintenance-governance]
   - [ ] Archived: rely on GitHub's built-in archived-repository banner; no custom badge needed

   Each badge should link back to [Project Maintenance Governance][project-maintenance-governance]
   so readers can look up what the status means.
4. Post an update to the project's [GitHub discussion for checkins][project-checkins-discussions] explaining the change and what it means for users.
5. If moving into Dormant or Commons Stewardship, add a short note near the top of the
`README.md` pointing users to the [Contributor Trust Ladder][contributor-trust-ladder]
in case they're interested in stepping up as a maintainer.
6. If moving into Archived, confirm the repository is archived via GitHub settings
   (Settings > General > Danger Zone > Archive this repository) so it becomes read-only.
7. Update the [Django Commons Project Checkins doc][project-checkins-doc] to reflect the new status.

[1]: https://github.com/django-commons/membership/blob/main/terraform/org.tfvars

[2]: https://github.com/django-commons/membership/blob/main/terraform/repositories.tfvars

[1password]: https://djangocommons.1password.com/

[google-drive]: https://drive.google.com/drive/folders/1N61xE5_f0ePijMm0joT1SeLzDlsXGjKD?usp=sharing

[open-collective]: https://opencollective.com/django-commons

[forum-moderators]: https://forum.djangoproject.com/t/extending-the-forum-for-django-commons/41040

[pypi-org]: https://pypi.org/org/django-commons/

[teams-page]: https://github.com/django-commons/membership/blob/main/docs/team.md

[incoming-requirements]: https://github.com/django-commons/membership/blob/main/incoming_repo_requirements.md

[people]: https://github.com/orgs/django-commons/people

[teams]: https://github.com/orgs/django-commons/teams

[failed-invitations]: https://github.com/orgs/django-commons/people/failed_invitations

[test-pypi]: https://test.pypi.org/manage/project/django-commons/

[pypi]: https://pypi.org/

[gh-docs-transfer-repo]: https://docs.github.com/en/repositories/creating-and-managing-repositories/transferring-a-repository

[release-gh-workflow]: https://github.com/django-commons/best-practices/blob/main/.github/workflows/release.yml

[pypi-publishing]: https://test.pypi.org/manage/project/django-tasks-scheduler/settings/publishing/

[best-practice-environments]: https://github.com/django-commons/best-practices/settings/environments

[team-roles]: https://github.com/django-commons/membership?tab=readme-ov-file#what-is-each-repository-team-for

[project-checkins-doc]: https://docs.google.com/spreadsheets/d/1MV0IGyS32EY_NtEq67MMYj2bqOv05imF5QP6I1KGhF8/edit?usp=sharing

[project-checkins-discussions]: https://github.com/orgs/django-commons/discussions/categories/check-ins

[pypi-org]: https://pypi.org/manage/organization/django-commons/projects/

[readthedocs]: https://readthedocs.org/

[open-collective]: https://opencollective.com/dashboard/django-commons/accounts

[project-maintenance-governance]: https://github.com/django-commons/membership/blob/main/docs/governance/project-maintenance.md

[contributor-trust-ladder]: https://github.com/django-commons/membership/blob/main/docs/governance/project-maintenance.md#contributor-trust-ladder-for-dormant-and-archived-projects
