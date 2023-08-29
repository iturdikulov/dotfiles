{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.sdcv;
in {
  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      sdcv
    ];

    env = {
      STARDICT_DATA_DIR = "$XDG_CONFIG_HOME/Reference/dictionary";
    };
  };
}
