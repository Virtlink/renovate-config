# Renovate Configs
Reusable Renovate presets for Virtlink repositories.

## Presets

| Preset           | Purpose |
| ---------------- | ------- |
| `default`        | Shared policy: `chore/` branches, no dependency dashboard, three-day release age, stable releases only, strict internal checks, no separate major/minor branches, and CI automerge with squash PR merges. |
| `ci`             | Enables GitHub Actions and GitLab CI managers and groups their updates as `CI configuration`. |
| `github-actions` | Enables only the GitHub Actions manager, scans repository workflows plus `template/**/workflows`, and groups updates as `GitHub Actions`. |
| `gradle`         | Enables Gradle and Gradle wrapper managers, limits scanning to the repository Gradle catalog/settings/wrapper files, and groups final Gradle releases as `Gradle dependencies`. |


## Usage
Add one preset to the `extends` array in your `renovate.json`.

Use the shared defaults only:

```json
{
  "extends": [
    "github>virtlink/renovate-config"
  ]
}
```

Use CI grouping plus the shared defaults:

```json
{
  "extends": [
    "github>virtlink/renovate-config:ci"
  ]
}
```

Use GitHub Actions grouping plus the shared defaults:

```json
{
  "extends": [
    "github>virtlink/renovate-config:github-actions"
  ]
}
```

Use Gradle grouping plus the shared defaults:

```json
{
  "extends": [
    "github>virtlink/renovate-config:gradle"
  ]
}
```

Use multiple focused presets together when a repository needs them:

```json
{
  "extends": [
    "github>virtlink/renovate-config:ci",
    "github>virtlink/renovate-config:gradle"
  ]
}
```

Each focused preset extends `github>virtlink/renovate-config`, so users do not need to list the default preset separately.


## Repository automation
The [documentation](https://pelsmaeker.net/renovate-config/) explains how to configure a repository or project to use this shared configuration:

- GitHub: create and install the GitHub App, configure repository secrets, protect the default branch, enable auto-merge, and add the reusable workflow.
- GitLab: create an API token, configure CI/CD variables, include the reusable CI job, and schedule Renovate.

## Development
Use mise to install the local Renovate validator and run the same validation as CI:

```sh
mise install
mise run check:renovate
```

The validator runs `renovate-config-validator --strict` against `renovate-github-config.json`, `renovate-gitlab-config.json`, and `default.json`.
