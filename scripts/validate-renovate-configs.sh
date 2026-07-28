#!/usr/bin/env bash
set -euo pipefail

src="${1:-.}"
out="${2:-}"

tmpdir="$(mktemp -d "${TMPDIR:-/tmp}/renovate-configs.XXXXXX")"
trap 'rm -rf "$tmpdir"' EXIT

cd "$src"

repo_config=renovate.json
sources=(default.json ci.json github-actions.json gradle.json)
focused=(ci.json github-actions.json gradle.json)

jq empty "$repo_config" "${sources[@]}"
jq -e '.extends == ["github>virtlink/renovate-config"]' "$repo_config" > /dev/null
renovate-config-validator --strict --no-global "$repo_config"

work="$tmpdir/source"
sanitized="$tmpdir/sanitized"
mkdir -p "$work" "$sanitized"
cp "${sources[@]}" "$work/"
cd "$work"

jq -e '.extends == null' default.json > /dev/null
for config in "${focused[@]}"; do
  jq -e '.extends == ["github>virtlink/renovate-config"]' "$config" > /dev/null
  jq 'del(.extends)' "$config" > "$sanitized/$config"
done

renovate-config-validator --strict --no-global default.json "$sanitized"/*.json

merge_config() {
  jq -s '.[0] as $base | .[1] as $leaf | ($base * ($leaf | del(.extends))) | .packageRules = (($base.packageRules // []) + ($leaf.packageRules // []))' default.json "$1" > "$tmpdir/$2.json"
}

merge_config ci.json ci
merge_config github-actions.json github-actions
merge_config gradle.json gradle

flattened=("$tmpdir/ci.json" "$tmpdir/github-actions.json" "$tmpdir/gradle.json")
renovate-config-validator --strict --no-global "${flattened[@]}"

for config in "${flattened[@]}"; do
  jq -e '
    .branchPrefix == "chore/"
    and .minimumReleaseAge == "3 days"
    and .minimumReleaseAgeBehaviour == "timestamp-required"
    and .internalChecksFilter == "strict"
    and .ignoreUnstable == true
    and .separateMajorMinor == false
    and .dependencyDashboard == false
  ' "$config" > /dev/null
done

jq -e '
  .enabledManagers == ["github-actions", "gitlabci"]
  and any(.packageRules[]; .groupName == "CI configuration" and .groupSlug == "ci-configuration" and .matchManagers == ["github-actions", "gitlabci"])
  and any(.packageRules[]; .description == "Automerge GitHub Actions and GitLab CI updates using squash merges." and .matchManagers == ["github-actions", "gitlabci"] and .automerge == true and .automergeType == "pr" and .automergeStrategy == "squash")
' "$tmpdir/ci.json" > /dev/null

jq -e '
  .enabledManagers == ["github-actions"]
  and .["github-actions"].managerFilePatterns == ["/^\\.github/workflows/[^/]+\\.ya?ml$/", "/^template/.*workflows/[^/]+\\.ya?ml$/"]
  and any(.packageRules[]; .groupName == "GitHub Actions" and .groupSlug == "github-actions" and .matchManagers == ["github-actions"])
  and any(.packageRules[]; .description == "Automerge GitHub Actions and GitLab CI updates using squash merges." and .matchManagers == ["github-actions", "gitlabci"] and .automerge == true and .automergeType == "pr" and .automergeStrategy == "squash")
' "$tmpdir/github-actions.json" > /dev/null

jq -e '
  .enabledManagers == ["gradle", "gradle-wrapper"]
  and .includePaths == ["gradle/libs.versions.toml", "settings.gradle.kts", "gradle/wrapper/gradle-wrapper.properties"]
  and any(.packageRules[]; .groupName == "Gradle dependencies" and .groupSlug == "gradle-dependencies" and .matchManagers == ["gradle", "gradle-wrapper"] and .allowedVersions == "/^\\d+(?:\\.\\d+)+(?:[.-](?:final|release|ga))?$/i")
  and ([.packageRules[] | select((.matchManagers // []) | index("gradle") or index("gradle-wrapper")) | select(.automerge == true)] | length == 0)
' "$tmpdir/gradle.json" > /dev/null

if [[ -n "$out" ]]; then
  touch "$out"
fi
