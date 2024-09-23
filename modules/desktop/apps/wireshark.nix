{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.wireshark;
in {
  options.modules.desktop.apps.wireshark = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.wireshark.enable = true;

    user.packages = with pkgs; [
      wireshark
    ];

    user.extraGroups = [ "wireshark" ];
  };
}