{
  lib,
  pkgs,
  ...
}: {
  imports = [./configuration.nix ./hardware-configuration.nix];
  networking.hostName = lib.mkDefault "nixos-base";
  users = {
    mutableUsers = true;
    users.root.initialHashedPassword = "$6$HZNrjQs87sc4J2t2$7PlhQOkRaj9pU1HD0bQAXKqHSeIAqp6USoNxJUwZFk82.8mauAjFB7ECh9HIzBe.MA7HoAW0uc33ZXXo.F/S/0";
  };
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };
  environment.systemPackages = with pkgs; [
    vim
  ];
}
