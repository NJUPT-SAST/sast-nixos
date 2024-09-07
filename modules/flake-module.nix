{ inputs, ... }:

{
  flake.nixosModules = {
    default.imports = [
      inputs.srvos.nixosModules.server
      inputs.srvos.nixosModules.mixins-trusted-nix-caches
      ./machine/pkgs.nix
    ];

    installer.imports = [
      inputs.srvos.nixosModules.server
      inputs.srvos.nixosModules.mixins-trusted-nix-caches
    ];
  };
}
