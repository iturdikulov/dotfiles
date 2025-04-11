{ options, config, pkgs, ... }:

{
  services.calibre-web = {
    enable = true;
    user = config.user.name;
    group = "syncthing";
    options.calibreLibrary = "${config.user.home}/Arts_and_Entertainment/literature";
    listen.ip = "127.0.0.1";
    listen.port = 8080;
  };

  services.nginx.virtualHosts."books.home.arpa" = {
    http2 = true;
    locations."/".proxyPass = "http://127.0.0.1:8080";
  };

  networking.firewall.allowedTCPPorts = [ 8080 ];
}