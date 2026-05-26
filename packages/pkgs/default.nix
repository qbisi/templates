{ lib, self, ... }:
{
  flake.overlays.default =
    final: prev:
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

      packages = packagesFromFiles {
        inherit (final) callPackage;
        directory = ./by-name;
      };

      pythonOverrides =
        pythonFinal: pythonPrev:
        packagesFromFiles {
          inherit (pythonFinal) callPackage;
          directory = ./python-by-name;
        }
        // {
          pkgs = pythonPrev.pkgs // final;
        };
    in
    packages
    // {
      inherit pythonOverrides;

      python3 = prev.python3.override (old: {
        packageOverrides = lib.composeExtensions (old.packageOverrides or (_: _: { })) pythonOverrides;
      });

      python3Packages = lib.recurseIntoAttrs final.python3.pkgs;
    };

  flake.nixosModules.default = {
    nixpkgs.overlays = [ self.overlays.default ];
  };

  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    {
      legacyPackages = lib.removeAttrs (lib.makeScope pkgs.newScope (
        final: self.overlays.default final pkgs
      )) [ "packages" ];
    };
}
