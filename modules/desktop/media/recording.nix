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
    capture.enable = mkBoolOpt true;
    audio.enable = mkBoolOpt true;
    tools.enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.capture.enable {
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

      user.packages = with pkgs; [
        unstable.obs-studio  # For recording footage
      ];
    })

    (mkIf cfg.audio.enable {
      user.packages = with pkgs; [
        unstable.audacity
        reaper
      ];
    })

    (mkIf cfg.tools.enable {
      user.packages = with pkgs; [
        ffmpeg-full
        handbrake
      ];
    })
  ]);
}