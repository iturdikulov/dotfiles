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
      socat # to remote control mpv

      # Web-torrent integration
      jq
      xidel
      nodePackages.webtorrent-cli

      (mpv.override {
        youtubeSupport = true;
        scripts = with mpvScripts; [
          mpris
          uosc
          thumbfast
          mpv-playlistmanager
          autoload
          acompressor
        ];
      })

      mpvc  # CLI controller for mpv
    ];

    home.configFile = {
      "mpv/mpv.conf".source   = "${configDir}/mpv/mpv.conf";
      "mpv/input.conf".source = "${configDir}/mpv/input.conf";
      "mpv/scripts" = { source = "${configDir}/mpv/scripts"; recursive = true; };

      "mpv/script-opts/uosc.conf".source   = "${configDir}/mpv/uosc.conf";
    };
  };
}