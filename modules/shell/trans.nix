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

      # TODO: need to extract into separate script and simplify logic
      (writeScriptBin "D" ''
        #!/bin/sh

        if [[ $# -gt 0 ]]; then
            CONTENT=$@
            source=$(trans -id $CONTENT|sed -n 's/^Code *//p')
        else
            CONTENT=$(wl-paste -n)
            source=$($CONTENT|trans -id|sed -n 's/^Code *//p')
        fi

        if [[ $source == *ru* ]]; then
            target=en
        else
            target=ru
        fi

        echo Translation from $source to $target

        if [[ $# -gt 0 ]]; then
            ${getExe' pkgs.translate-shell "trans"} -brief -target $target -play -join $@
        else
            wl-paste -n|${getExe' pkgs.translate-shell "trans"} -brief -target $target -play -join $@
        fi
       '')
    ];
  };
}