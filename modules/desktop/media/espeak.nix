# modules/desktop/media/espeak.nix
#

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.media.espeak;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.media.espeak = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
       unstable.piper-tts
       xdotool
       xclip
       alsa-utils
    ];

    home.dataFile = {
      "piper_model" = {
        source = "${configDir}/piper/model";
        recursive = true;
      };
    };
  };
}