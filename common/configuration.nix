{
  imports = [./hardware-configuration.nix];
  boot.loader.grub.device = "/dev/sda";
  system.stateVersion = "25.05";
}
