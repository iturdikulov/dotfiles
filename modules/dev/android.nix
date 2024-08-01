{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.android;
in {
  options.modules.dev.android = {
    enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        android-studio
      ];

      env.ANDROID_HOME = "$XDG_DATA_HOME/android";
      env.PATH = [ "$ANDROID_HOME/tools" "$ANDROID_HOME/platform-tools" ];
    })
  ];
}