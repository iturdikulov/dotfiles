{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.resilio;
in {
  options.modules.services.resilio= {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.extraGroups = [ "rslsync" ];

    services.resilio = {
      enable = true;
      enableWebUI = true;
    };

    system.activationScripts."resilio" = ''
      ${getExe' pkgs.acl "setfacl"} -d -m group:rslsync:rwx ${config.user.home}
      ${getExe' pkgs.acl "setfacl"} -m group:rslsync:rwx ${config.user.home}
    '';
  };
}