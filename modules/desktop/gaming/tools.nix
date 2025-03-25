{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.gaming.emulators;
in {
  options.modules.desktop.gaming.tools = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      # GUI for mapping keyboard and mouse controls to a gamepad
      # check also: https://github.com/AntiMicroX/antimicrox-profiles
      antimicrox
    ];
  };
}