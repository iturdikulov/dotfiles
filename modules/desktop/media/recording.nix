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
    # Virtual cam settings: see https://wiki.nixos.org/wiki/OBS_Studio#Using_the_Virtual_Camera
    boot.extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
    boot.extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="Web Cam" exclusive_caps=1
    '';
    boot.kernelModules = with config.boot.kernelModules; [
      "v4l2loopback"
    ];
    security.polkit.enable = true;

    user.packages = with pkgs;
      # for recording and remastering audio
      (if cfg.audio.enable then [ unstable.audacity reaper ] else []) ++
      # for longer term streaming/recording the screen
      (if cfg.video.enable then [
        obs-studio
        ffmpeg-full
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