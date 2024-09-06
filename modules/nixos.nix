{ lib, ... }:

let
  inherit (builtins)
    attrNames
    listToAttrs
    readDir
    filter
    pathExists
    ;
  inherit (lib) nameValuePair;
  inherit (lib.list) head;

  # TODO: use more robust way to get machineDir
  machineDir = head (
    filter (dir: pathExists (./. + "${dir}")) [
      "../../../machines"
      "../../machines"
    ]
  );
  machines = attrNames (readDir (./. + "${machineDir}"));

  toNixOSSystem =
    machines:
    listToAttrs (
      map (
        machine: (nameValuePair machine { imports = [ (./. + "${machineDir}/${machine}") ]; })
      ) machines
    );

in
{
  flake.nixosConfigurations = toNixOSSystem machines;
}
