{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.tealdeer;
in {
  options.modules.shell.tealdeer = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.tealdeer ];
  };
}
