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
    ];
  };
}