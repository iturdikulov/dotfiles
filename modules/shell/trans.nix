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
      translate-shell

      (writeScriptBin "tn" ''
        #!/bin/sh
        ${getExe' pkgs.translate-shell "trans"} :ru -speak -join $@
       '')
    ];
  };
}