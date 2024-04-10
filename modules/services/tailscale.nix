{ options, config, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.tailscale;
in {
  options.modules.services.tailscale = {
    enable = mkBoolOpt false;
    routingFeatures = mkOption {
      type = with types; uniq str;
      default = "none";
    };
  };

  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      useRoutingFeatures = cfg.routingFeatures;
    };
  };
}