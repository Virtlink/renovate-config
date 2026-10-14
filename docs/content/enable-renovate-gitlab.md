---
title: "Enable Renovate merge requests"
---
# Enable Renovate merge requests on GitLab

## Create the Renovate configuration

Add `renovate-config.json` to the project root. It must select the GitLab platform:

```json title="renovate-config.json"
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "platform": "gitlab",
  "extends": ["github>virtlink/renovate-config"],
  "enabledManagers": ["github-actions", "gitlabci"]
}
```

Set `enabledManagers` to the Renovate managers used by the project.

## Create the access token

Create a GitLab personal, project, or group access token with the `api` scope. Give its bot user at least the Developer role on the target project so Renovate can create branches and merge requests. If protected-branch merge restrictions apply, grant the role required to merge into that branch, which can be Maintainer.

## Configure CI/CD variables

In the project _Settings_, _CI/CD_, _Variables_, add:

- `RENOVATE_TOKEN`: the access token. Mark it _Masked_. Mark it _Protected_ only when the scheduled pipeline runs on a protected branch.
- `RENOVATE_GITHUB_COM_TOKEN`: optional GitHub token for authenticated GitHub changelog and source lookups. This is useful when GitHub's unauthenticated rate limit is insufficient.

## Add the pipeline configuration

Add the reusable job to the project's `.gitlab-ci.yml`:

```yaml title=".gitlab-ci.yml"
---
include:
  - project: "virtlink/renovate-config"
    ref: main
    file: "/.gitlab/ci/renovate.yml"
```

The included job reads `renovate-config.json` from the project root. For a nonstandard path, override only `RENOVATE_CONFIG_FILE` and ensure that file sets `"platform": "gitlab"`:

```yaml title=".gitlab-ci.yml"
renovate:
  variables:
    RENOVATE_CONFIG_FILE: path/to/renovate-gitlab-config.json
```

## Schedule or run Renovate

1. Go to _Build_, _Pipeline schedules_ and create a schedule for the project's default branch.
2. Add the schedule variable `RENOVATE` with the value `true`.
3. Set the desired cron schedule and activate it.

The included job runs only for scheduled pipelines with `RENOVATE=true`. For an on-demand run, start a web pipeline from _Build_, _Pipelines_, then run the manual `renovate` job. Push and merge-request pipelines do not run Renovate.

The shared preset requests squash auto-merge. GitLab will merge only when the token's role and the project's merge-request and protected-branch rules allow it.
