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
This repository runs self-hosted Renovate from `.github/workflows/renovate.yaml` using `renovate-config.json` as the global configuration file.

The workflow runs every Saturday at `03:17` UTC and can also be started manually with `workflow_dispatch`.

Configure these repository secrets for the workflow:

- `APP_CLIENT_ID`: GitHub App client ID.
- `APP_PRIVATE_KEY`: GitHub App private key PEM contents.

The GitHub App needs repository permissions for contents read/write, pull requests read/write, workflows read/write, and metadata read-only.


## Development
Enter the Nix development shell, then run the same Renovate validator used by CI:

```sh
nix develop
bash scripts/validate-renovate-configs.sh
```

Or run the full flake check:

```sh
nix flake check
```

The validation runs `renovate-config-validator --strict` against the self-hosted `renovate-config.json`, validates the base and focused presets with `--no-global`, then validates focused presets flattened with `default.json`.
