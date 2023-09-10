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
        scripts = with mpvScripts; [
          mpris
          uosc
          thumbfast
          mpv-playlistmanager
          autoload
          autocrop
          acompressor
        ];
      })

      mpvc  # CLI controller for mpv
    ];

    home.configFile = {
      "mpv/mpv.conf".source   = "${configDir}/mpv/mpv.conf";
      "mpv/input.conf".source = "${configDir}/mpv/input.conf";
      "mpv/scripts" = { source = "${configDir}/mpv/scripts"; recursive = true; };
    };
  };
}