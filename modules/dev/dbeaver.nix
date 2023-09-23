{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.dbeaver;
in {
  options.modules.dev.dbeaver = {
    enable = mkBoolOpt false;
  };

  config = {
      user.packages = with pkgs; [
        dbeaver
      ];
  };
}