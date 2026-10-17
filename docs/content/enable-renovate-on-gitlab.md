---
title: "Enable Renovate on a GitLab repository"
---
# How to configure and enable Renovate on a GitLab repository

## Configure the repository
1.  Go to the project's settings and modify the topics to add: `renovate-managed`
2.  [Enable auto-merge PRs](./gitlab-automerge-prs-after-ci.md).
3.  Add a `renovate.json` to enable Renovate:

    ```json title="renovate.json"
    {
      "$schema": "https://docs.renovatebot.com/renovate-schema.json",
      "extends": ["github>my-org/renovate-config"]
    }
    ```
