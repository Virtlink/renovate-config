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

        bash "$src/scripts/validate-renovate-configs.sh" "$src" "$out"
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
