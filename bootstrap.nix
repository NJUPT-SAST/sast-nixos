{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./common
  ];
  virtualbox = {
    # see: https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/virtualbox-image.nix
    memorySize = 4000; # MiB
    params = {
      # audiocontroller = "off";
      audio = "none";
      audioout = "off";
    };
  };
  virtualisation.diskSize = 40 * 1024;
  virtualisation.vmware.guest.enable = true;

  system.stateVersion = "25.05";
}
