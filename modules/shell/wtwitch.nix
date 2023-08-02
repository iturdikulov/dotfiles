{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.wtwitch;
    configDir = config.dotfiles.configDir;
in {
  options.modules.shell.wtwitch = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      wtwitch
    ];

    home.configFile."wtwitch/config.json".source = "${configDir}/wtwitch/config.json";
  };
}
