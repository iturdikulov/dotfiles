{ options, config, pkgs, ... }:

{
  services.nginx.virtualHosts."iturdikulov.home.arpa" = {
    http2 = true;
    root = "/var/www/iturdikulov/";
    locations."/"= {
        tryFiles = "$uri $uri.html $uri/ =404";
    };
  };
}