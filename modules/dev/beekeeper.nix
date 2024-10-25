{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.beekeeper;
in {
  options.modules.dev.beekeeper = {
    enable = mkBoolOpt false;
  };

  config = {
      user.packages = with pkgs; [
        beekeeper-studio
      ];
  };
}