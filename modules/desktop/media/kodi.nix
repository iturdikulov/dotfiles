{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.media.kodi;
in {
  options.modules.desktop.media.kodi = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    env.CRASHLOG_DIR = "$XDG_STATE_HOME";

    user.packages = with pkgs; [
      (pkgs.unstable.kodi-wayland.withPackages (kodiPkgs: with kodiPkgs; [
        jellyfin
      ]))
    ];
  };
}