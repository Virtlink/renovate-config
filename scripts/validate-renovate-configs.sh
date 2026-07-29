#!/usr/bin/env bash
set -euo pipefail

src="${1:-.}"
out="${2:-}"

cd "$src"

repo_config=renovate-config.json
default_config=default.json

renovate-config-validator --strict "$repo_config"
renovate-config-validator --strict "$default_config"

if [[ -n "$out" ]]; then
  touch "$out"
fi
