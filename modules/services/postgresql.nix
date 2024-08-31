{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.postgresql;
in {
  options.modules.services.postgresql = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      ensureDatabases = [ "expirement" ];
      authentication = pkgs.lib.mkOverride 10 ''
        #type database  DBuser  auth-method
        local all       all     trust
      '';
      package = pkgs.unstable.postgresql;
    };
  };
}