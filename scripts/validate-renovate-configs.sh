#!/usr/bin/env bash
set -euo pipefail

src="${1:-.}"
out="${2:-}"

cd "$src"

renovate_config=renovate-github-config.json
gitlab_config=renovate-gitlab-config.json
default_config=default.json

renovate-config-validator --strict "$renovate_config"
renovate-config-validator --strict "$gitlab_config"
renovate-config-validator --strict "$default_config"

if [[ -n "$out" ]]; then
  touch "$out"
fi
