{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.rabbitmq;
in {
  options.modules.services.rabbitmq = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.rabbitmq = {
      enable = true;
    };
  };
}