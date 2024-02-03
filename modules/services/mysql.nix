{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.mysql;
in {
  options.modules.services.mysql = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.mysql = {
      enable = true;
      package = pkgs.mariadb;

      # Add some default databases
      ensureDatabases = [ "photoprism" ];

      # Add some default users
      ensureUsers = [ {
        name = "photoprism";
        ensurePermissions = {
          "photoprism.*" = "ALL PRIVILEGES";
        };
      } ];
    };
  };
}