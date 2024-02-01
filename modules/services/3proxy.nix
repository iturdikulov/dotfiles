{ config, options, lib, pkgs, ... }:

with builtins;
with lib;
with lib.my;
let cfg = config.modules.services._3proxy;
in {
  options.modules.services._3proxy = {
    enable = mkBoolOpt false;
    openPort = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.extraGroups = [ "_3proxy" ];

      services._3proxy = {
        enable = true;
        services = [
          {
            type = "proxy";
              auth = [ "strong" ];
              acl = [ {
                rule = "allow";
                users = [ "inom_3proxy" ];
              }
            ];
          }
        ];
        usersFile = "/etc/_3proxy.passwd";
      };

      environment.etc = {
        "_3proxy.passwd".text = ''$(cat "${config.age.secrets._3proxy.path}")'';
      };
    })

    (mkIf cfg.openPort {
      networking.firewall.allowedTCPPorts = [ 3128 ];
    })
  ];
}