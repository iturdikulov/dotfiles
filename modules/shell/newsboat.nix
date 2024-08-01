{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.newsboat;
    configDir = config.dotfiles.configDir;
in {
  options.modules.shell.newsboat = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      unstable.newsboat
    ];

    home.configFile = {
      "newsboat/config".source = "${configDir}/newsboat/config";
      "newsboat/urls".source = "${configDir}/newsboat/urls";
    };
  };
}