# modules/services/qbittorrent.nix
#

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.qbittorrent;
in {
  options.modules.services.qbittorrent = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        qbittorrent = prev.qbittorrent.override { guiSupport = false; };
      })
    ];

    users.users.qbittorrent = {
      home = "/var/lib/qbittorrent";
      group = "qbittorrent";
      createHome = true;
      description = "qBittorrent Daemon user";
      isSystemUser = true;
    };
    users.groups.qbittorrent = { gid = null; };

    systemd.services.qbittorrent = {
      after = [ "network.target" ];
      description = "qBittorrent Daemon";
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.qbittorrent ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.qbittorrent}/bin/qbittorrent-nox \
            --profile=/var/lib/qbittorrent/.config \
            --webui-port=4096
        '';
        # To prevent "Quit & shutdown daemon" from working; we want systemd to
        # manage it!
        Restart = "on-success";
        User = "qbittorrent";
        Group = "qbittorrent";
        UMask = "0002";
        LimitNOFILE = 4096;
      };
    };

    services.nginx.virtualHosts."torrent.home.arpa" = {
      http2 = true;
      locations."/".proxyPass = "http://127.0.0.1:4096";
    };

    # networking.firewall =  {
    #   allowedTCPPorts = [ 8081 ];
    #   allowedUDPPorts = [ 8081 ];
    # };

    # services.fail2ban.jails.qbittorrent = ''
    #   enabled = true
    #   filter = qbittorrent
    #   banaction = %(banaction_allports)s
    #   maxretry = 5
    # '';
  };
}