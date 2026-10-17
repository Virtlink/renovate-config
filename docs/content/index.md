---
title: "Home"
---
# Renovate config

Shared configuration and automation for running self-hosted Renovate on Virtlink projects.

## Choose a platform

| Platform | Guide |
| --- | --- |
| GitHub | [Enable Renovate pull requests](./enable-renovate-on-github.md) |
| GitLab | [Enable Renovate merge requests](./enable-renovate-on-gitlab.md) |

GitHub users first create and install a [GitHub App](./create-github-app.md), then configure [branch protection and auto-merge](./github-automerge-prs-after-ci.md).

GitLab users first create a [Service account](./create-gitlab-service-account.md), then configure [auto-merge](./gitlab-automerge-prs-after-ci.md)

## Renovate shared configuration

Add `renovate.json` to every repository or project that should receive dependency updates. Select the hosting platform and the managers that the repository uses.

=== "GitHub"

    ```json title="renovate.json"
    {
      "$schema": "https://docs.renovatebot.com/renovate-schema.json",
      "extends": ["local>my-org/renovate-config"],
    }
    ```

=== "GitLab"

    ```json title="renovate.json"
    {
      "$schema": "https://docs.renovatebot.com/renovate-schema.json",
      "extends": ["github>my-org/renovate-config"],
    }
    ```

The shared policy creates `renovate/` branches, waits three days for new releases, excludes unstable releases, groups CI updates, and requests squash auto-merge after repository checks pass.

## Developing this documentation

To view this documentation locally:

```shell
cd docs/
uv run zensical serve
```

This publishes the documentation at [localhost:8000](http://localhost:8000/) by default and watches for documentation source changes.
