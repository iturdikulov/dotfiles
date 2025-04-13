# modules/services/qbittorrent.nix
#

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.qbittorrent;
in {
  options.modules.services.qbittorrent = {
    enable = mkBoolOpt false;
    profile = mkOption rec {
      type = types.path;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        qbittorrent = prev.qbittorrent.override { guiSupport = false; };
      })
    ];

    systemd.services.qbittorrent = {
      after = [ "network.target" ];
      description = "qBittorrent Daemon";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.qbittorrent ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.qbittorrent}/bin/qbittorrent-nox \
            --profile=${cfg.profile} \
            --webui-port=4096
        '';
        # To prevent "Quit & shutdown daemon" from working; we want systemd to
        # manage it!
        Restart = "on-success";
        User = "multimedia";
        Group = "multimedia";
        UMask = "0002";
        LimitNOFILE = 4096;
      };
    };

    services.nginx.virtualHosts."torrent.home.arpa" = {
      http2 = true;
      locations."/".proxyPass = "http://127.0.0.1:4096";
    };
  };
}