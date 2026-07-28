{
  description = "Reusable Renovate presets";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      validationScript = ''
        set -euo pipefail
        cd "$src"

        sources=(default.json ci.json github-actions.json gradle.json)
        jq empty "''${sources[@]}"

        work="$TMPDIR/source"
        mkdir -p "$work"
        cp "''${sources[@]}" "$work/"
        cd "$work"

        renovate-config-validator --strict --no-global "''${sources[@]}"

        merge_config() {
          jq -s '.[0] as $base | .[1] as $leaf | ($base * $leaf) | .packageRules = (($base.packageRules // []) + ($leaf.packageRules // []))' default.json "$1" > "$TMPDIR/$2.json"
        }

        merge_config ci.json ci
        merge_config github-actions.json github-actions
        merge_config gradle.json gradle

        flattened=("$TMPDIR/ci.json" "$TMPDIR/github-actions.json" "$TMPDIR/gradle.json")
        renovate-config-validator --strict --no-global "''${flattened[@]}"

        for config in "''${flattened[@]}"; do
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
        ' "$TMPDIR/ci.json" > /dev/null

        jq -e '
          .enabledManagers == ["github-actions"]
          and .["github-actions"].managerFilePatterns == ["/^\\.github/workflows/[^/]+\\.ya?ml$/", "/^template/.*workflows/[^/]+\\.ya?ml$/"]
          and any(.packageRules[]; .groupName == "GitHub Actions" and .groupSlug == "github-actions" and .matchManagers == ["github-actions"])
          and any(.packageRules[]; .description == "Automerge GitHub Actions and GitLab CI updates using squash merges." and .matchManagers == ["github-actions", "gitlabci"] and .automerge == true and .automergeType == "pr" and .automergeStrategy == "squash")
        ' "$TMPDIR/github-actions.json" > /dev/null

        jq -e '
          .enabledManagers == ["gradle", "gradle-wrapper"]
          and .includePaths == ["gradle/libs.versions.toml", "settings.gradle.kts", "gradle/wrapper/gradle-wrapper.properties"]
          and any(.packageRules[]; .groupName == "Gradle dependencies" and .groupSlug == "gradle-dependencies" and .matchManagers == ["gradle", "gradle-wrapper"] and .allowedVersions == "/^\\d+(?:\\.\\d+)+(?:[.-](?:final|release|ga))?$/i")
          and ([.packageRules[] | select((.matchManagers // []) | index("gradle") or index("gradle-wrapper")) | select(.automerge == true)] | length == 0)
        ' "$TMPDIR/gradle.json" > /dev/null

        touch "$out"
      '';
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShellNoCC {
            packages = [
              pkgs.jq
              pkgs.renovate
            ];
          };
        }
      );

      checks = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          renovate-configs = pkgs.runCommand "validate-renovate-configs" { nativeBuildInputs = [ pkgs.jq pkgs.renovate ]; src = ./.; } validationScript;
        }
      );
    };
}
