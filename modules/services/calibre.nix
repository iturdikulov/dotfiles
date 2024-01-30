{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.calibre;
in {
  options.modules.services.calibre = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # I use built-in server in calibre
    networking.firewall.allowedTCPPorts = [ 8080 ];
    user.packages = [ pkgs.calibre ];
  };
}