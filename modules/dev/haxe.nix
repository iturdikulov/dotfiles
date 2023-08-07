{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.haxe;
in {
  options.modules.dev.haxe = {
    enable = mkBoolOpt false;
  };

  config = {
    user.packages = with pkgs; [
      haxe_4_1
    ];
  };
}
