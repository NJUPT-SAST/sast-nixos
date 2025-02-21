{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nixos-generators,
    ...
  }: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in {
    ## NOTE: from https://github.com/nix-community/nixos-generators/issues/128#issuecomment-1484084499
    packages."x86_64-linux" = {
      nixovabase = let
        unfixed = nixos-generators.nixosGenerate {
          modules = [./bootstrap.nix];
          format = "virtualbox";
        };
        #vmx = "vmx-13"; # used for ESXi 6.7
        vmx = "vmx-17"; # used for ESXi 7.0
      in
        pkgs.runCommand "nixovabase" {} ''
          ova=${unfixed}/*.ova
          mkdir $out
          # cp $ova "$out/unfixed.ova"  # debug
          ${pkgs.cot}/bin/cot --force --verbose edit-product $ova -p 'Some Info' -o nixos.ova
          ${pkgs.cot}/bin/cot --force --verbose edit-hardware nixos.ova -v ${vmx}
          tar xf nixos.ova
          sed -i -E 's/^(\s*<(ovf:)?ProductSection)>\s*$/\1 ovf:required="false">/' *.ovf
          sed -i -E "s/^(SHA1\(nixos.ovf\)=\s*).*$/\1$(sha1sum nixos.ovf | cut -d ' ' -f 1)/" *.mf
          ${nixpkgs.legacyPackages.x86_64-linux.ovftool}/bin/ovftool --lax --sourceType=OVF --targetType=OVA nixos.ovf $out/nixos.ova
          # tar cf $out/nixos.ova *.ovf *.mf *.vmdk
        '';
    };
    devShells."x86_64-linux".default = pkgs.mkShell {
      packages = with pkgs; [
        just
      ];
    };

    ## Service Machine Start
    nixosConfigurations = {
      sast-nixos-001 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [./common ./hosts/nixos-misaka-001];
      };
    };
  };
}
