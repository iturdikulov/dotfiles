{ config, lib, pkgs, ... }:

# https://www.zahradnik.io/wireguard-a-vpn-with-real-world-usage-in-mind/
# https://www.wireguardconfig.com/
# https://github.com/ryantm/agenix/blob/main/modules/age.nix
# https://github.com/NixOS/nixos-org-configurations/tree/master/modules
{
  networking = {
    firewall.allowedUDPPorts = [
      51821
    ];
    nat.enable = true;
  };
}