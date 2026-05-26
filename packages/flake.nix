{
  description = "Package set flake template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    flake-compat.url = "github:nix-community/flake-compat";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      imports = [
        ./pkgs
      ];

      perSystem =
        {
          pkgs,
          lib,
          system,
          self',
          ...
        }:
        let
          packagesFromFiles =
            {
              callPackage,
              directory,
            }:
            lib.mapAttrs' (
              fileName: _:
              lib.nameValuePair (lib.removeSuffix ".nix" fileName) (callPackage (directory + "/${fileName}") { })
            ) (lib.filterAttrs (fileName: type: type == "regular" && lib.hasSuffix ".nix" fileName) (
              builtins.readDir directory
            ));
        in
        {
          _module.args = {
            pkgs = import inputs.nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
          };

          formatter = pkgs.nixfmt;

          packages =
            (packagesFromFiles {
              inherit (self'.legacyPackages) callPackage;
              directory = ./pkgs/by-name;
            })
            // (lib.mapAttrs' (name: value: lib.nameValuePair "python3-${name}" value) (
              packagesFromFiles {
                inherit (self'.legacyPackages.python3Packages) callPackage;
                directory = ./pkgs/python-by-name;
              }
            ));
        };
    };
}
