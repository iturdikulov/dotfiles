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
  time.timeZone = "Asia/Bishkek";
  networking.networkmanager.enable = true;
}