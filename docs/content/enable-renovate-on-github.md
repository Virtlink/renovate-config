---
title: "Enable Renovate on a GitHub repository"
---
# How to configure and enable Renovate on a GitHub repository

## Configure the repository
1.  [Enable auto-merge PRs on GitHub](./automerge-prs-after-ci.md).

2.  Add a `renovate.json` to enable Renovate:

    ```json title="renovate.json"
    {
      "$schema": "https://docs.renovatebot.com/renovate-schema.json",
      "extends": ["local>my-org/renovate-config"]
    }
    ```