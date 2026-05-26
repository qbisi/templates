# Package Set Template

This template defines packages through an overlay first, then exposes the
overlay-built attributes as flake packages.

It also works as a non-flake package set:

```nix
let
  pkgs = import ./. { };
in
pkgs.hello-template
```

## Layout

- `default.nix` imports nixpkgs with this repository's overlay applied.
- `flake-compat.nix` loads the flake outputs for non-flake evaluation.
- `.github/workflows/update-packages.yml` updates packages with `passthru.updateScript` every day.
- `pkgs/default.nix` defines `overlays.default`, `nixosModules.default`, and `legacyPackages`.
- `pkgs/by-name/<name>.nix` defines normal packages.
- `pkgs/python-by-name/<name>.nix` defines Python packages.

The NixOS module applies this flake's default overlay to `nixpkgs.overlays`.

Python packages are exposed in two places:

- `legacyPackages.<system>.python3Packages.<name>`
- `packages.<system>.python3-<name>`

Normal packages are exposed as:

- `legacyPackages.<system>.<name>`
- `packages.<system>.<name>`
