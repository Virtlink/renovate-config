# Renovate Configs
Reusable Renovate preset for your repositories.

## Presets
`default.json` is the shared policy preset. It extends Renovate's recommended configuration and:

- Requires releases to be at least three days old and have a timestamp.
- Labels pull requests with `dependencies`, limits open Renovate pull requests to five, and uses `renovate/` branches.
- Auto-merge stable minor and patch updates after checks pass; major updates require review and receive the `major-update` label.

## Usage
Set your `renovate.json` to this:

```json
{
  "$schema": "https://docs.renovatebot.com/renovate-schema.json",
  "extends": [
    "github>Virtlink/renovate-config"
  ]
}
```

## Repository automation
The [documentation](https://pelsmaeker.net/renovate-config/) explains how to configure a repository or project to use this shared configuration.

## Development
Use mise to install the local Renovate validator and run the same validation as CI:

```sh
mise install
mise run check:renovate
```

The validator runs `renovate-config-validator --strict` against `default.json`.
