{ config, options, pkgs, ... }:

{
  services.syncthing = rec {
    enable = true;
    openDefaultPorts = true;
    guiAddress = "0.0.0.0:8384";
    user = config.user.name;
    configDir = "${config.user.home}/.config/syncthing";
    dataDir = "${config.user.home}/.local/share/syncthing";
  };

  services.nginx.virtualHosts."sync.home.arpa" = {
    http2 = true;
    locations."/".proxyPass = "http://127.0.0.1:8384";
  };
}