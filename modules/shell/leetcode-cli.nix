{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.leetcode-cli;
    configDir = config.dotfiles.configDir;
in {
  options.modules.shell.leetcode-cli = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      leetcode-cli
    ];
  };
}