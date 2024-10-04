# oka -- my remote server

{ config, lib, pkgs, ... }:

with lib.my;
{
  imports = [
    ../home.nix
    ./hardware-configuration.nix
  ];


  ## Modules
  modules = {
    shell = {
      direnv.enable = true;
      git.enable = true;
      zsh.enable = true;
    };
    services = {
      ssh.enable = true;
    };

    theme.active = "alucard";
  };

  ## Local config
  networking.networkmanager.enable = true;

  # Allow some apps to run without password request for sudo
  # TODO: merge this with oka into tun2proxy module?
  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [
        {
          command = "${pkgs.my.tun2proxy}/bin/tun2proxy";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/etc/profiles/per-user/${config.user.name}/bin/tun2proxy";
          options = [ "NOPASSWD" ];
        }
      ];
      groups = [ "wheel" ];
    }];
  };
}