## This repo contains:

- Code to generate base nixos ovf image for vmware ESXi
- Configuration for nixos host definition(packages/services/...)
- Tools to easily rebuild and switch nixos profile remotely

## Usage:

- Prerequests: `nix` and `just`
- use `just bootstrap` to get nixos ova image(`result/nixos.ova`)
- use `just remote-switch .#machine_name machine_user@machine_ip`
  to update/switch nixos configuration
