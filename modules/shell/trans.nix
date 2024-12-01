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
      python3.packages.cyrtranslit

      # TODO: need to extract into separate script and simplify logic
      (writeScriptBin "D" ''
        #!/bin/sh
        if [[ $# -gt 0 ]]; then
            CONTENT=$@
        else
            CONTENT=$(wl-paste -n)
        fi

        RU_PATTERN='[А-Яа-яЁё]+'  # Regex pattern for Cyrillic characters
        if [[ "$CONTENT" =~ $RU_PATTERN ]]; then
            target="en"
        else
            target="ru"
        fi

        ${getExe' pkgs.translate-shell "trans"} -brief -target $target -play -join $CONTENT
       '')
    ];
  };
}