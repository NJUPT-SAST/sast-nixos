{pkgs, ...}: {
  networking.hostName = "nixos-misaka-001";
  services.nginx = {
    enable = true;
    virtualHosts = {
      "localhost" = {
        locations."/" = {
          index = "index.html";
          root = pkgs.writeTextDir "index.html" ''
            <html>
            <body>
            Hello, world!
            </body>
            </html>
          '';
        };
      };
    };
  };
  networking.firewall.allowedTCPPorts = [80];
}
