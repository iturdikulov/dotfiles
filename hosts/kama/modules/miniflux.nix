{ options, config, pkgs, ... }:

{
    services.miniflux = {
      enable = true;
      config = {
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