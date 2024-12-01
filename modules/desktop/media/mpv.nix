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
      socat     # to remote control mpv
      playerctl # playback control (for mpris)
      mpvc  # CLI controller for mpv

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

      # Script to open the latest recording in mpv
      (pkgs.writeScriptBin "latest_record" ''
        #!/bin/sh
        RECORDINGS_DIR="$HOME/Arts_and_Entertainment/audiovisual/record"
        [ -d $RECORDINGS_DIR ] || echo "No $RECORDINGS_DIR directory found"
        RECORDING="$RECORDINGS_DIR/$(ls -Art $RECORDINGS_DIR|tail -n 1)"
        echo "Opening $RECORDING and copying to clipboard"
        echo "$RECORDING"| wl-copy
        nmpv --loop-file=yes "$RECORDING"
      '')

      # Open files with mpv in the background without blocking the terminal
      (writeScriptBin "nmpv" ''
        #!/bin/sh
        ${pkgs.mpv}/bin/mpv "$@" > /dev/null 2>&1 &
      '')
    ];

    home.configFile = {
      "mpv/mpv.conf".source   = "${configDir}/mpv/mpv.conf";
      "mpv/input.conf".source = "${configDir}/mpv/input.conf";
    };
  };
}