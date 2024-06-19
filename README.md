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
3. The [new_member](https://github.com/django-commons/membership/blob/main/.github/workflows/new_member.yml) action will send the invite and close the issue
4. Add the member to any relevant teams if requested

If they aren't a real human or reasonably trustworthy, close the issue.

## Team Change Playbook

1. If they are a real human and are reasonably trustworthy, comment "Approved" and close the issue manually
2. Add the member to requested team(s)

## New Repository Admin Playbook

1. Confirm with all existing admins that they are okay with the prospective admin
2. If there's disagreement, close the issue and ask for the admins to come to a consensus
3. If there's agreement, add the prospective admin to the [repo]-admins team

## New Project Playbook

1. Check if repository meets [inbound requirements](https://github.com/django-commons/membership/blob/main/incoming_repo_requirements.md)
2. Confirm who will be the admins and maintainers for the repository
3. PyPI project owner must add you (Django Commons admin) as owner in PyPI
4. (TODO: Determine how this works with transfering out of an org and into the Django Commons org)
5. [Add repository owner to Django Commons as member](https://github.com/orgs/django-commons/people) (they'll be added to a team later)
6. Share link ([https://docs.github.com/en/repositories/creating-and-managing-repositories/transferring-a-repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/transferring-a-repository)) with repo owner to transfer repo
7. Wait for repository transferred in
8. [Run new team action](https://github.com/django-commons/controls/actions/workflows/new_team.yml)
9. Invite repository admins to [repo]-admins team, repository maintainers to [repo]-committers team
10. Configure environments pypi and testpypi
11. For pypi environment, add Deployment protection rule with reviewers as [repo]-admins and enable "Allow administrators to bypass configured protection rules"
12. Under Actions > General > "Fork pull request workflows from outside collaborators", set "Require approval for first-time contributors"
13. Add previous repository owner to [repo]-admins team
14. Set a calender event or reminder for 30 days in the future to remove previous repository owner from team

## Remove Project Playbook

1. Confirm there's agreement amongst current project maintainers to move project out of Django Commons
2. Add new Owner(s) to project in PyPI
3. [Transfer GitHub repo to new owner or Org](https://github.com/orgs/django-commons/people)
4. Wait for repository to be transferred out.
5. [Delete top-level team for repository](https://github.com/orgs/django-commons/teams) (the delete will cascade to the sub-teams)
6. Remove all Django Commons members from PyPI project (except any that are staying on from step 2)
7. (TODO: Determine how to handle transferring a PyPI project out of an organization)
