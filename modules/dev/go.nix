{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.go;
in {
  options.modules.dev.go = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.xdg.enable {
      env.GOPATH = "$XDG_DATA_HOME/go";
      env.PATH = [ "$GOPATH/bin" ];
    })

    (mkIf cfg.enable {
      user.packages = with pkgs; [
        go
        gotools
        gore  # Yet another Go REPL that works nicely.
      ];
    })
  ];
}