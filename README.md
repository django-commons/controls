# Django Commons Controls
This repository contains all the information for administrators to manage
Django Commons packages.


## New Member Playbook
1. Review new issues/application at https://github.com/django-commons/membership/issues/
2. If they are a real human and are reasonably trustworthy, response with "Approved" and nothing else
3. The [new_member](https://github.com/django-commons/membership/blob/main/.github/workflows/new_member.yml) action will send the invite and close the issue
4. Add the member to any relevant teams if requested

If they aren't a real human or reasonably trustworthy, close the issue.

## New Project Playbook

1. Check if repository meets requirements (TODO: write doc)
2. Confirm who will be the admins and maintainers for the repository
3. PyPI project owner must add you (Django Commons admin) as owner in PyPI
4. (TODO: Determine how this works with transfering out of an org and into the Django Commons org)
5. [Add repository owner to Django Commons as member](https://github.com/orgs/django-commons/people) (they'll be added to a team later)
6. Share link ([https://docs.github.com/en/repositories/creating-and-managing-repositories/transferring-a-repository](https://docs.github.com/en/repositories/creating-and-managing-repositories/transferring-a-repository)) with repo owner to transfer repo
7. Wait for repository transferred in
8. [Run new team action](https://github.com/django-commons/controls/actions/workflows/new_team.yml)
9. Invite repository admins to [repo]-admins team, repository maintainers to [repo]-maintainers team

## Remove Project Playbook

1. Confirm there's agreement amongst current project maintainers to move project out of Django Commons
2. Add new Owner(s) to project in PyPI
3. [Transfer GitHub repo to new owner or Org](https://github.com/orgs/django-commons/people)
4. Wait for repository to be transferred out.
5. [Delete top-level team for repository](https://github.com/orgs/django-commons/teams) (the delete will cascade to the sub-teams)
6. Remove all Django Commons members from PyPI project (except any that are staying on from step 2)
7. (TODO: Determine how to handle transferring a PyPI project out of an organization)
