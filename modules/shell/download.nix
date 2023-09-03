{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.download;
    configDir = config.dotfiles.configDir;
in {
  options.modules.shell.download = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wget
      aria
      yt-dlp
      gallery-dl
    ];

    # wget configuration
    home.configFile."wgetrc".source = "${configDir}/wget/wgetrc";
  };
}