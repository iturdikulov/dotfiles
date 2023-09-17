{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.calibre;
in {
  options.modules.services.calibre = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.calibre-server.enable = true;
    services.calibre-server.libraries = [ "${config.user.home}/Arts_and_Entertainment/literature" ];
    networking.firewall.allowedTCPPorts = [ 8080 ];
    services.calibre-server.user = "${config.user.name}";
  };
}