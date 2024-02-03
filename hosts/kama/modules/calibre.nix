{ options, config, pkgs, ... }:

{
  services.calibre-server = {
    enable = true;
    port = 8080;
    libraries = [ "${config.user.home}/Arts_and_Entertainment/literature" ];
    user = "${config.user.name}";
  };

  services.nginx.virtualHosts."books.home.arpa" = {
    http2 = true;
    locations."/".proxyPass = "http://127.0.0.1:8080";
  };

  networking.firewall.allowedTCPPorts = [ 8080 ];
}