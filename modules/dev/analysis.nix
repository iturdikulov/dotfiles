# modules/dev/analysis

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  devCfg = config.modules.dev;
  cfg = devCfg.analysis;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.dev.analysis = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      cloc # Counts blank lines, comment lines, and physical lines
    ];
  };
}