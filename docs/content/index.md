---
title: "Home"
---
# Renovate config
Shared configuration and GitHub Actions workflow for running self-hosted Renovate on Virtlink projects.


## Renovate shared configuration
To use the shared Renovate configuration, add a `renovate-config.json` file to the repository that should receive dependency updates:

```json title="renovate-config.json"
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "platform": "github",
  "extends": ["github>virtlink/renovate-config"],
  "enabledManagers": ["github-actions", "gitlabci"]
}
```

Set `enabledManagers` in the consuming repository to the Renovate managers that repository should use.
The example above enables dependency updates for GitHub Actions workflows and GitLab CI files.


## Renovate GitHub shared workflow
Use the reusable workflow from this repository to run Renovate from GitHub Actions:

```yaml title=".github/workflows/renovate.yaml"
---
name: 'Renovate'

on:  # yamllint disable-line rule:truthy
  schedule:
    # Run at 03:17 on Saturday
    - cron: '17 3 * * 6'
  workflow_dispatch:
  
concurrency:
  group: ${{ github.workflow }}
  cancel-in-progress: false

jobs:
  update-dependencies:
    name: 'Update dependencies'
    uses: virtlink/renovate-config/.github/workflows/renovate.yaml@main
    with:
      log-level: info
    secrets:
      client-id: ${{ secrets.APP_CLIENT_ID }}
      client-private-key: ${{ secrets.APP_PRIVATE_KEY }}
```

The reusable workflow checks out the consuming repository and runs Renovate with `renovate-config.json` by default.
Override the config path only when the consuming repository stores its Renovate config somewhere else:

```yaml
with:
  renovate-config-file: path/to/renovate-config.json
```

Configure these repository secrets in the consuming repository:

- `APP_CLIENT_ID`: GitHub App client ID.
- `APP_PRIVATE_KEY`: GitHub App private key PEM contents.

The GitHub App needs these repository permissions:

- Commit statuses: read and write.
- Contents: read and write.
- Metadata: read-only.
- Pull requests: read and write.
- Workflows: read and write.

GitHub Actions must also be allowed to create and approve pull requests.



## Renovate GitLab shared CI configuration
Use the reusable GitLab CI configuration from this repository to run Renovate from GitLab pipelines.
For GitLab projects, add a `renovate-config.json` file with `platform` set to `gitlab`:

```json title="renovate-config.json"
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "platform": "gitlab",
  "extends": ["github>virtlink/renovate-config"],
  "enabledManagers": ["github-actions", "gitlabci"]
}
```

Then include the reusable job from the consuming repository's `.gitlab-ci.yml`:

```yaml title=".gitlab-ci.yml"
---
include:
  - project: "virtlink/renovate-config"
    ref: main
    file: "/.gitlab/ci/renovate.yml"
```

The reusable job reads `renovate-config.json` by default.
For dual-hosted repositories or nonstandard layouts, override only the config file path and make sure the selected file sets `"platform": "gitlab"`:

```yaml title=".gitlab-ci.yml"
renovate:
  variables:
    RENOVATE_CONFIG_FILE: path/to/renovate-gitlab-config.json
```

Configure a masked `RENOVATE_TOKEN` CI/CD variable containing a GitLab personal, project, or group access token with `api` scope.
The token needs at least the Developer role on the target project.
Protected-branch merge restrictions can require Maintainer access.

Optionally configure `RENOVATE_GITHUB_COM_TOKEN` when Renovate needs authenticated GitHub changelog or source lookups.

To run Renovate automatically, configure a pipeline schedule with the variable `RENOVATE=true`.
To run Renovate on demand, start a web pipeline and manually run the `renovate` job.
Ordinary pushes and merge-request pipelines do not run Renovate.

## Developing this documentation
To view this documentation locally:

```shell
cd docs/
uv run zensical serve
```

This publishes the documentation at [localhost:8000](http://localhost:8000/) by default and watches for documentation source changes.


