{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.sdcv;
in {
  options.modules.shell.sdcv = with types; {
    enable   = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      sdcv
    ];

    env = {
      STARDICT_DATA_DIR = "$HOME/Reference/dictionary";
    };
  };
}