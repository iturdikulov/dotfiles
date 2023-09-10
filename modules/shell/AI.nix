{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.AI;
in {
  options.modules.shell.AI = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      chatgpt-cli
      my.tungsten
    ];
  };
}