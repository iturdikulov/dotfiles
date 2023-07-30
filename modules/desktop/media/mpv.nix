{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.media.mpv;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.media.mpv = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      # Web-torrent integration
      jq
      xidel
      nodePackages.webtorrent-cli

      (mpv.override {
        youtubeSupport = true;
        scripts = [
          mpvScripts.mpris
          mpvScripts.webtorrent-mpv-hook
          mpvScripts.uosc
        ];
      })

      mpvc  # CLI controller for mpv
    ];

    home.configFile = {
      "mpv/mpv.conf".source   = "${configDir}/mpv/mpv.conf";
      "mpv/input.conf".source = "${configDir}/mpv/input.conf";
    };
  };
}
