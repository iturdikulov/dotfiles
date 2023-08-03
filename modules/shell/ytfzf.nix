{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.ytfzf;
in {
  options.modules.shell.ytfzf = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.ytfzf ];
  };
}
