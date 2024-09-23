{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.rabbitmq;
in {
  options.modules.services.rabbitmq = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    env.RABBITMQ_NODENAME = "rabbit@127.0.0.1";
    services.rabbitmq = {
      enable = true;
    };
  };
}