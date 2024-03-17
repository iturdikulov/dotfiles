{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.yewtube;
in {
  options.modules.shell.yewtube = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.yewtube ];
  };
}