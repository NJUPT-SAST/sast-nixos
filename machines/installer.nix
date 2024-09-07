{ self, ... }:

{
  imports = [ self.nixosModules.installer ];
}
