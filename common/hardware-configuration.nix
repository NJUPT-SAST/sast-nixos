{lib, ...}: {
  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "ehci_pci" "ahci" "sd_mod"];
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      fsType = "ext4";
    };
  };
  swapDevices = [
    {
      device = "/var/swap";
      size = 2048;
    }
  ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
