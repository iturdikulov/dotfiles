{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.termdown;
in {
  options.modules.shell.termdown = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.termdown ];
  };
}
