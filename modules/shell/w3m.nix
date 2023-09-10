{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.w3m;
    configDir = config.dotfiles.configDir;
in {
  options.modules.shell.w3m = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      w3m
    ];

    home.file = {
      ".w3m/config".source = "${configDir}/w3m/config";
      ".w3m/keymap".source = "${configDir}/w3m/keymap";
    };
  };
}
