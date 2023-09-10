{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.network;
    configDir = config.dotfiles.configDir;
in {
  options.modules.shell.network = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wget
      aria
      yt-dlp
      gallery-dl
      cloudflared
    ];

    # Configurations
    home.configFile."wgetrc".source = "${configDir}/wget/wgetrc";
    home.configFile."yt-dlp/config".text = ''
    --format bestvideo[ext=mp4]+bestaudio[ext=m4a]
    '';
  };
}