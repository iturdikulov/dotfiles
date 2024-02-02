{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.android;
in
{
  options.modules.hardware.android = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.adb.enable = true;
    user.extraGroups = [ "adbusers" ];

    user.packages = with pkgs; [
      scrcpy

      # Custom scrcpy desktop item
      (makeDesktopItem {
        name = "scrcpy (custom)";
        desktopName = "scrcpy (custom)";
        genericName = "Android remote control";
        icon = "scrcpy";
        exec = "/bin/sh -c \"\\$SHELL -i -c scrcpy --hid-keyboard\"";
      })
    ];
  };
}