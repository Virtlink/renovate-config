---
title: "Enable Renovate PRs"
---
# Enable Renovate PRs on GitHub

## Prerequisites

1. Create and install a [GitHub App](./create-github-app.md). You need its Client ID and private-key `.pem` file.
2. Ensure the app has access to the repository that will receive Renovate pull requests.

## Configure repository secrets

In the repository's settings, under _Secrets and variables_, _Actions_, add the following secrets to _Repository secrets_:

- `APP_CLIENT_ID`: the GitHub App's Client ID
- `APP_PRIVATE_KEY`: the entire contents of the `.pem` file (the GitHub App's private key)

!!! note ""
    The private key is a multi-line string. Make sure to copy the entire contents of the `.pem` file. For example:

    ```
    -----BEGIN RSA PRIVATE KEY-----
    MIIEpgIBAAKCAQEAm9KB2dFRW9iRaRpdaUCWwPxRzlI3hmZxGWX60ump49NuJ4XM
    ...
    RR5z3JpJfVU4pfu8rOeEURBgLuUM4JMho2qU769I8VVlDTjRpRaaITp1
    -----END RSA PRIVATE KEY-----
    ```

## Protect the default branch and allow auto-merge

[Enable auto-merge](./automerge-prs-after-ci.md).

!!! note ""
    Some guides on the internet discuss the following additional steps, but they are not necessary when using a GitHub App instead of the `GITHUB_TOKEN`:

    - Allow GitHub Actions to create and approve pull requests
    - Workflow permissions: Read and write permissions

## Add the workflow

Create `.github/workflows/renovate.yaml` in the repository:

```yaml title=".github/workflows/renovate.yaml"
---
name: 'Renovate'

on:  # yamllint disable-line rule:truthy
  schedule:
    # Run at 06:00 on Saturday
    - cron: "0 6 * * 1"
  workflow_dispatch: # Allow manual triggering

concurrency:
  group: ${{ github.workflow }}
  cancel-in-progress: false

jobs:
  update-dependencies:
    name: 'Update dependencies'
    uses: virtlink/renovate-config/.github/workflows/renovate.yaml@main
    with:
      log-level: debug
    secrets:
      client-id: ${{ secrets.APP_CLIENT_ID }}
      client-private-key: ${{ secrets.APP_PRIVATE_KEY }}
```

The reusable workflow reads `renovate-config.json` from the repository root. Add that file as described on the [documentation home page](./index.md), or pass `renovate-config-file` when it lives elsewhere.
