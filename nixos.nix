{
  lib,
  inputs,
  self,
  ...
}:

let
  inherit (builtins)
    attrNames
    readDir
    filter
    pathExists
    ;
  inherit (lib) genAttrs nixosSystem;
  inherit (lib.list) head;

  installerSupportArch = [
    "x86_64-linux"
  ];

  # TODO: use more robust way to get machineDir
  machineDir = head (
    filter (dir: pathExists (./. + "${dir}")) [
      "../../../machines"
      "../../machines"
      "../machines"
    ]
  );
  machines = attrNames (readDir (./. + "${machineDir}"));

  toNixOSSystem =
    machines:
    genAttrs machines (
      machine:
      nixosSystem {
        modules = [ (./. + "${machineDir}/${machine}") ];
      }
    );

in
{
  flake.nixosConfigurations = toNixOSSystem machines;

  # installer iso, for boostrap
  flake.packages = genAttrs installerSupportArch (system: {
    "installer" = inputs.nixos-generators.nixosGenerate {
      inherit system;
      format = "install-iso";
      specialArgs = {
        self = {
          inputs = self.inputs;
          nixosModules = self.nixosModules;
        };
      };
      modules = [ ./machines/installer.nix ];
    };
  });
}
