{ inputs, ... }:

{
  flake.nixosModules = {
    default.imports = [
      inputs.srvos.nixosModules.server
      inputs.srvos.nixosModules.mixins-trusted-nix-caches
      ./pkgs.nix
    ];
  };
}
