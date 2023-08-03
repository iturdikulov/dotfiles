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
       (writeScriptBin "piper_speak" readFile ["${configDir}/piper/piper_speak"])
       piper
    ];

    home.dataFile = {
      "piper_model" = {
        source = "${configDir}/piper/model";
        recursive = true;
      };
    };
  };
}
