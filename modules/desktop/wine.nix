{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.wine;
in {
  options.modules.desktop.wine = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wineWowPackages.staging # wine-staging (version with experimental features)
      winetricks
      protontricks
      protonup-qt
      # native wayland support (unstable)
      # wineWowPackages.waylandFull
    ];
  };
}