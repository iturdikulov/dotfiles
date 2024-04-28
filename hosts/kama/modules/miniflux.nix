{ options, config, pkgs, ... }:

{
    services.miniflux = {
      enable = true;
      config = {
        CLEANUP_ARCHIVE_UNREAD_DAYS = "-1";
        CLEANUP_ARCHIVE_READ_DAYS = "-1";
        FILTER_ENTRY_MAX_AGE_DAYS = "36500";
        CLEANUP_FREQUENCY = "48";
        LISTEN_ADDR = "localhost:8081";
      };

      # TODO: replace with agenix
      adminCredentialsFile = "/etc/nixos/miniflux-admin-credentials";
    };

    services.nginx.virtualHosts."rss.home.arpa" = {
      http2 = true;
      locations."/".proxyPass = "http://127.0.0.1:8081";
    };

    services.postgresql.package = pkgs.postgresql;
    networking.firewall.allowedTCPPorts = [ 8081 ];
}