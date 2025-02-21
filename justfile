bootstrap:
    env NIXPKGS_ALLOW_INSECURE=1 NIXPKGS_ALLOW_UNFREE=1 nix build --impure .#nixovabase

remote-switch flake target:
    nixos-rebuild switch --flake '{{ flake }}' --target-host '{{ target }}' --show-trace --verbose

update:
    @nix flake update
