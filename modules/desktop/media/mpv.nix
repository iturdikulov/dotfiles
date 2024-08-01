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

      # Playback control (for mpris)
      playerctl

      (mpv.override {
        youtubeSupport = true;
        scripts = with mpvScripts; [
          mpris
          thumbfast
          mpv-playlistmanager
          autoload
          acompressor
          vr-reversal
        ];
      })

      mpvc  # CLI controller for mpv

      # Open files with mpv in the background without blocking the terminal
      (writeScriptBin "nmpv" ''
        #!/bin/sh
        ${pkgs.mpv}/bin/mpv "$@" > /dev/null 2>&1 &
      '')
    ];

    home.configFile = {
      "mpv/mpv.conf".source   = "${configDir}/mpv/mpv.conf";
      "mpv/input.conf".source = "${configDir}/mpv/input.conf";
      "mpv/scripts" = { source = "${configDir}/mpv/scripts"; recursive = true; };
    };
  };
}