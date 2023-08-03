{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.chatgpt-cli;
in {
  options.modules.shell.chatgpt-cli = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [ pkgs.chatgpt-cli ];
  };
}
