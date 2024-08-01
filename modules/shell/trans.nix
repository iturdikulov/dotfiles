{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.crow-translate;
in {
  options.modules.shell.crow-translate = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      pkgs.crow-translate

      (writeScriptBin "trans" ''
        #!/bin/sh
        crow -t ru+en "$@"|bat --style=grid --terminal-width=80
       '')
    ];
  };
}