# modules/desktop/media/recording.nix
#
# OBS to capture footage/stream, audacity for audio, handbrake to encode it all.
# This, paired with DaVinci Resolve for video editing (on my Windows system) and
# I have what I need for youtube videos and streaming.

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.media.recording;
in {
  options.modules.desktop.media.recording = {
    enable = mkBoolOpt false;
    audio.enable = mkBoolOpt true;
    video.enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    services.pipewire.jack.enable = true;

    user.packages = with pkgs;
      # for recording and remastering audio
      (if cfg.audio.enable then [ unstable.audacity reaper ] else []) ++
      # for longer term streaming/recording the screen
      (if cfg.video.enable then [
         obs-studio
         unstable.handbrake
         unstable.ffmpeg-full
        (pkgs.writeScriptBin "latest_record" ''
        #!/bin/sh
        RECORDINGS_DIR="$HOME/Videos/record"
        [ -d $RECORDINGS_DIR ] || echo "No $RECORDINGS_DIR directory found"
        RECORDING="$HOME/Videos/record/$(ls -Art $HOME/Videos/record|tail -n 1)"
        echo "$RECORDING"| xclip -sel c
        mpv --loop-file=yes "$RECORDING"
        '')
      ] else []);
  };
}