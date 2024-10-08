{
  description = "SAST NixOS Infra";

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { self, lib, ... }:
      {
        systems = [
          "aarch64-linux"
          "x86_64-linux"

          "x86_64-darwin"
          "aarch64-darwin"
        ];

        imports = [
          inputs.treefmt-nix.flakeModule

          ./modules/flake-module.nix
          ./nixos.nix
        ];

        perSystem =
          {
            self',
            system,
            pkgs,
            config,
            ...
          }:
          {
            devShells.default = pkgs.mkShell {
              nativeBuildInputs = [
                config.treefmt.build.wrapper
              ];
            };

            treefmt = (import ./treefmt.nix);
          };
      }
    );

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    srvos.url = "github:numtide/srvos";
    srvos.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.inputs.nixpkgs-stable.follows = "";
  };
}
