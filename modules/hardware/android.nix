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

      (makeDesktopItem {
        name = "scrcpy-keyboard";
        desktopName = "scrcpy (keyboard)";
        icon = "scrcpy";
        exec = "${getExe' scrcpy "scrcpy"} --no-video --keyboard=aoa";
      })

      (makeDesktopItem {
        name = "scrcpy-camera";
        desktopName = "scrcpy (camera)";
        icon = "scrcpy";
        exec = "${getExe' scrcpy "scrcpy"} --video-source=camera --no-audio --camera-ar=1:1 -m1920 --v4l2-sink=/dev/video1 --capture-orientation=90";
      })
    ];
  };
}