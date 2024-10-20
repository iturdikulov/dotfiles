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
      ".w3m/keymap".source = "${configDir}/w3m/keymap";

      ".w3m/config".text = ''
        confirm_qq false
        # Open page in the default browser or firefox
        extbrowser xdg-open %s
        extbrowser2 firefox %s

        # Auto enable VIM html file type for editor command
        editor vim -c "set filetype=html"

        # run external viewers/commands in background
        bgextviewer 1
      '';

    };

  };
}