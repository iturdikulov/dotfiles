{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.miniflux;
in {
  options.modules.services.miniflux = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.miniflux = {
      enable = true;
      config = {
        CLEANUP_FREQUENCY = "48";
        LISTEN_ADDR = "100.121.182.21:8080";
      };

      # TODO: replace with agenix
      adminCredentialsFile = "/etc/nixos/miniflux-admin-credentials";
    };

    services.postgresql.package = pkgs.postgresql;
    networking.firewall.allowedTCPPorts = [ 8080 ];
  };
}