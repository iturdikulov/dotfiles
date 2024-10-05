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
    user.packages = with pkgs; [
      curlHTTP3
      qbittorrent
      cloudflared
      aria
      yt-dlp
      gallery-dl
      wget
      nmap
      whois
      unstable.copilot-cli
      unstable.awscli2
      unstable.ssm-session-manager-plugin
      my.tun2proxy
      proxychains
    ];

    ## Custom ENV variables
    env.GLOBAL_SOCKS5_PROXY = (with config.networking.globalProxy; "${host}:${port}");
    env.GLOBAL_HTTP_PROXY = (with config.networking.globalProxy; "${builtins.replaceStrings ["socks5"] ["http"] host}:${port}");
    env.GLOBAL_SOCKS5H_PROXY = (with config.networking.globalProxy; "${builtins.replaceStrings ["socks5"] ["socks5h"] host}:${port}");

    # Allow tun2proxy to run without password request for sudo
    security.sudo.extraRules = [{
        commands = [
          {
            command = "${pkgs.my.tun2proxy}/bin/tun2proxy";
            options = [ "NOPASSWD" ];
          }
          {
            command = "/etc/profiles/per-user/${config.user.name}/bin/tun2proxy";
            options = [ "NOPASSWD" ];
          }
        ];
        groups = [ "wheel" ];
    }];

    # Configurations
    home.configFile."wgetrc".source = "${configDir}/wget/wgetrc";
    home.configFile."yt-dlp/config".text = ''
    --format bestvideo[ext=mp4]+bestaudio[ext=m4a]
    '';
  };
}