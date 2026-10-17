---
title: "Enable Renovate on a GitHub repository"
---
# How to configure and enable Renovate on a GitHub repository

## Configure the repository
1.  Modify the topics of the repository and add: `renovate-managed`
2.  [Enable auto-merge PRs on GitHub](./automerge-prs-after-ci.md).
3.  Add a `renovate.json` to enable Renovate:

    ```json title="renovate.json"
    {
      "$schema": "https://docs.renovatebot.com/renovate-schema.json",
      "extends": ["github>my-org/renovate-config"]
    }
    ```
