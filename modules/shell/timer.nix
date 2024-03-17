{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.timer;
in {
  options.modules.shell.timer = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.timer ];
  };
}