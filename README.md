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
Add this repository to the `extends` array in your `renovate.json`.

Use the shared defaults only:

```json
{
  "extends": [
    "github>virtlink/renovate-config"
  ]
}
```

Use the shared defaults plus CI grouping:

```json
{
  "extends": [
    "github>virtlink/renovate-config",
    "github>virtlink/renovate-config:ci"
  ]
}
```

Use the shared defaults plus Gradle grouping:

```json
{
  "extends": [
    "github>virtlink/renovate-config",
    "github>virtlink/renovate-config:gradle"
  ]
}
```

Use multiple focused presets together when a repository needs them:

```json
{
  "extends": [
    "github>virtlink/renovate-config",
    "github>virtlink/renovate-config:ci",
    "github>virtlink/renovate-config:gradle"
  ]
}
```

Include `github>virtlink/renovate-config` whenever you want the shared defaults.
Focused presets do not repeat `default.json` by themselves.


## Development
Enter the Nix development shell, then validate the presets:

```sh
nix develop
nix flake check
```

The validation checks that each JSON file is valid Renovate configuration and that focused presets still compose with `default.json`.
